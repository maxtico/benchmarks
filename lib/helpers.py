import json
from pathlib import Path
import sys
import time

import pandas as pd


JSON = str | int | float | bool | None | dict[str, "JSON"] | list["JSON"]


def get_config() -> JSON:
    return json.load(Path("config.json").open())


def library_to_language(library: str) -> str:
    print(get_config()["library_to_language"].get(library))
    return get_config()["library_to_language"].get(library)


def get_run_cmd(library: str, command: str) -> str:
    match language := library_to_language(library=library):
        case "py":
            cmd = command.replace("/", ".")
            return f"python -m {cmd}"
        case "sh":
            return f"sh {command}.sh"
        case "R":
            return "Rscript"
    msg = f"Could not find runner for language {language}"
    raise AssertionError(msg)


def get_files(library: str) -> tuple[pd.DataFrame, pd.DataFrame]:
    if library == "bioframe":
        from scripts.reading.bioframe import read
    elif library == "pyranges":
        from scripts.reading.pyranges import read

    annotations = read(Path(sys.argv[1]))
    reads = read(Path(sys.argv[2]))
    return annotations, reads


def get_file(library: str) -> tuple[pd.DataFrame, pd.DataFrame]:
    if library == "bioframe":
        from scripts.reading.bioframe import read
    elif library == "pyranges":
        from scripts.reading.pyranges import read

    annotations = read(Path(sys.argv[1]))
    return annotations


def write_result(operation: str, result: str) -> None:
    start = time.time()
    if operation == "binary":
        f = sys.argv[3]
    else:
        f = sys.argv[2]
    print(time.time() - start, "read sys argv")
    Path(f).write_text(result)


import json
import subprocess
import sys
import time
from pathlib import Path

import psutil

import json
import subprocess
import sys
import time
from pathlib import Path

import psutil

# ───── user-tunable limits ────────────────────────────────────────────────────
LIMIT_MB = 120_000  # hard RSS ceiling in MiB
TIMEOUT_S = 9000  # wall-clock limit in seconds
# ──────────────────────────────────────────────────────────────────────────────
LIMIT_BYTES = LIMIT_MB * 1024 * 1024


def run_case(
    cmd: str,
    *,
    benchmark_file: Path | str,
    result_file: Path | str,
    number_rows: int,
    library: str,
    genome: str,
    max_length: int,
    operation: str,
) -> dict:
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        shell=True,
    )
    ps = psutil.Process(proc.pid)
    start = time.perf_counter()
    peak_rss = 0
    status, error = "ok", ""

    try:
        while True:
            if proc.poll() is not None:  # child has finished
                break

            try:
                rss = ps.memory_info().rss
            except psutil.NoSuchProcess:  # PID already gone
                break

            peak_rss = max(peak_rss, rss)

            if rss > LIMIT_BYTES:  # memory guard
                proc.kill()
                status = "fail"
                error = (
                    f"RSS limit {LIMIT_MB} MiB exceeded (saw {rss / 1_048_576:.1f} MiB)"
                )
                break

            if time.perf_counter() - start > TIMEOUT_S:  # time guard
                proc.kill()
                status = "fail"
                error = f"timeout {TIMEOUT_S}s hit"
                break

            time.sleep(0.1)

    finally:
        rc = proc.wait()  # always reap the child
        stdout, stderr = proc.communicate()

        # if we didn’t already flag an error, use the exit-code
        if status == "ok" and rc != 0:
            status = "fail"
            error = f"child exited with code {rc}"

    benchmark = {
        "cmd": cmd,
        "status": status,
        "error": error,
        "seconds": round(time.perf_counter() - start, 3),
        "peak_rss": peak_rss,  # bytes
        "rc": rc,
        "stderr": stderr if len(stderr) < 500 else stderr[:250] + "\n...\n" + stderr[-250:],
        "number_rows": number_rows,
        "library": library,
        "genome": genome,
        "max_length": max_length,
        "operation": operation,
    }

    print(cmd)
    print(json.dumps(benchmark, indent=4))
    json.dump(benchmark, Path(benchmark_file).open("w+"), indent=4)
    if benchmark["status"] == "fail":
        Path(result_file).open("w+").write("Failed")
