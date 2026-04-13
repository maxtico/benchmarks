from helpers import run_case 

read_basenames = {"hg38": "HG00133.hg38.bed", "proteome": "all_proteome.bed"}
read_sizes = {"10_000": 10_000, "100_000": 100_000, "1_000_000": 1_000_000, "10_000_000": 10_000_000}

print("|".join([k for k, v in config["library_to_language"].items() if v == "py"]))
print("|".join(binary_operations.Operation))

#     number_rows: int,
#     library: str,
#     genome: str,
#     max_length: int,

rule binary_python:
    input:
        annotation = str(DOWNLOAD_DIR) + "/generated/annotation/{genome}/{nrows}/{maxlength}.bed",
        bed_file = str(DOWNLOAD_DIR) + "/generated/reads/{genome}/{nrows}/{maxlength}.bed"
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "py"]),
        operation = "|".join(binary_operations.Operation.drop_duplicates())
    benchmark:
        "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/snakemake_benchmark.jsonl"
    output:
        result = "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/result.txt",
        benchmark = "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/benchmark.json"
    run:
        module = f"scripts.binary.{wildcards.library}.{wildcards.operation}"
        print(subprocess.call("which python", shell=True))
        print(subprocess.call("python --version", shell=True))

        cmd = f"python -m {module} {input.annotation} {input.bed_file} {output.result}"

        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=wildcards.nrows,
            library=wildcards.library,
            genome=wildcards.genome,
            max_length=wildcards.maxlength,
            operation=wildcards.operation,
        )




rule binary_shell:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "sh"]),
        operation = "|".join(binary_operations.Operation)
    input:
        annotation = str(DOWNLOAD_DIR) + "/generated/annotation/{genome}/{nrows}/{maxlength}.bed",
        bed_file = str(DOWNLOAD_DIR) + "/generated/reads/{genome}/{nrows}/{maxlength}.bed"
    output:
        result = "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/result.txt",
        benchmark = "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/benchmark.json"
    benchmark:
        "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/snakemake_benchmark.jsonl"
    run:
        script = f"scripts/binary/{wildcards.library}/{wildcards.operation}"
        write_output_cmd = f" | tail > {output.result}"
        cmd = f"bash {script}.sh {input.annotation} {input.bed_file} {write_output_cmd}"

        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=wildcards.nrows,
            library=wildcards.library,
            genome=wildcards.genome,
            max_length=wildcards.maxlength,
            operation=wildcards.operation,
        )


rule binary_r:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "R"]),
        operation = "|".join(binary_operations.Operation)
    input:
        annotation = str(DOWNLOAD_DIR) + "/generated/annotation/{genome}/{nrows}/{maxlength}.bed",
        bed_file = str(DOWNLOAD_DIR) + "/generated/reads/{genome}/{nrows}/{maxlength}.bed"
    output:
        result = "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/result.txt",
        benchmark = "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/benchmark.json"
    benchmark:
        "{RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/{maxlength}/snakemake_benchmark.jsonl"
    run:
        script = f"scripts/binary/{wildcards.library}/{wildcards.operation}"
        cmd = f"Rscript {script}.R {input.annotation} {input.bed_file} {output.result}"
        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=wildcards.nrows,
            library=wildcards.library,
            genome=wildcards.genome,
            max_length=wildcards.maxlength,
            operation=wildcards.operation,
        )


rule binary_real_python:
    input:
        annotation = str(REAL_DOWNLOAD_DIR / "annotation/{nrows}/Homo_sapiens.GRCh38.115.bed"),
        bed_file = lambda wildcards: str(REAL_DOWNLOAD_DIR / f"reads/{wildcards.genome}/{wildcards.nrows}/{read_basenames[wildcards.genome]}")
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "py"]),
        operation = "|".join(binary_operations.Operation.drop_duplicates()),
        genome = "hg38|proteome",
        nrows = "10_000|100_000|1_000_000|10_000_000"
    benchmark:
        "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/snakemake_benchmark.jsonl"
    output:
        result = "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/result.txt",
        benchmark = "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/benchmark.json"
    run:
        module = f"scripts.binary.{wildcards.library}.{wildcards.operation}"
        cmd = f"python -m {module} {input.annotation} {input.bed_file} {output.result}"
        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=read_sizes[wildcards.nrows],
            library=wildcards.library,
            genome=wildcards.genome,
            max_length=0,
            operation=wildcards.operation,
        )


rule binary_real_shell:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "sh"]),
        operation = "|".join(binary_operations.Operation),
        genome = "hg38|proteome",
        nrows = "10_000|100_000|1_000_000|10_000_000"
    input:
        annotation = str(REAL_DOWNLOAD_DIR / "annotation/{nrows}/Homo_sapiens.GRCh38.115.bed"),
        bed_file = lambda wildcards: str(REAL_DOWNLOAD_DIR / f"reads/{wildcards.genome}/{wildcards.nrows}/{read_basenames[wildcards.genome]}")
    benchmark:
        "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/snakemake_benchmark.jsonl"
    output:
        result = "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/result.txt",
        benchmark = "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/benchmark.json"
    run:
        script = f"scripts/binary/{wildcards.library}/{wildcards.operation}"
        write_output_cmd = f" | tail > {output.result}"
        cmd = f"bash {script}.sh {input.annotation} {input.bed_file} {write_output_cmd}"
        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=read_sizes[wildcards.nrows],
            library=wildcards.library,
            genome=wildcards.genome,
            max_length=0,
            operation=wildcards.operation,
        )


rule binary_real_r:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "R"]),
        operation = "|".join(binary_operations.Operation),
        genome = "hg38|proteome",
        nrows = "10_000|100_000|1_000_000|10_000_000"
    input:
        annotation = str(REAL_DOWNLOAD_DIR / "annotation/{nrows}/Homo_sapiens.GRCh38.115.bed"),
        bed_file = lambda wildcards: str(REAL_DOWNLOAD_DIR / f"reads/{wildcards.genome}/{wildcards.nrows}/{read_basenames[wildcards.genome]}")
    benchmark:
        "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/snakemake_benchmark.jsonl"
    output:
        result = "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/result.txt",
        benchmark = "{REAL_RESULTS_DIR}/binary/{operation}/{library}/{genome}/{nrows}/benchmark.json"
    run:
        script = f"scripts/binary/{wildcards.library}/{wildcards.operation}"
        cmd = f"Rscript {script}.R {input.annotation} {input.bed_file} {output.result}"
        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=read_sizes[wildcards.nrows],
            library=wildcards.library,
            genome=wildcards.genome,
            max_length=0,
            operation=wildcards.operation,
        )