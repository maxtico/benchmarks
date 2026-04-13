from helpers import run_case 

read_sizes = {"10_000": 10_000, "100_000": 100_000, "1_000_000": 1_000_000, "10_000_000": 10_000_000}


rule unary_python:
    wildcard_constraints:
        operation_type = "unary",
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "py"]),
        operation = "|".join(unary_operations.Operation.drop_duplicates())
    input:
        str(DOWNLOAD_DIR) + "/generated/annotation/{genome}/{nrows}/{maxlength}.bed"
    output:
        result = "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/result.txt",
        benchmark = "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/benchmark.json"
    benchmark:
        "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/snakemake_benchmark.jsonl"
    run:
        module = f"scripts.unary.{wildcards.library}.{wildcards.operation}"

        cmd = f"python -m {module} {input} {output.result}"
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



rule unary_shell:
    wildcard_constraints:
        operation_type = "unary",
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "sh"]),
        operation = "|".join(unary_operations.Operation)
    input:
        str(DOWNLOAD_DIR) + "/generated/annotation/{genome}/{nrows}/{maxlength}.bed"
    output:
        result = "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/result.txt",
        benchmark = "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/benchmark.json"
    benchmark:
        "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/snakemake_benchmark.jsonl"
    run:
        script = f"scripts/unary/{wildcards.library}/{wildcards.operation}"
        write_output_cmd = f" | tail > {output.result}"
        cmd = f"bash {script}.sh {input[0]} {write_output_cmd}"

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


rule unary_r:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "R"]),
        operation = "|".join(unary_operations.Operation)
    input:
        str(DOWNLOAD_DIR) + "/generated/annotation/{genome}/{nrows}/{maxlength}.bed",
    output:
        result = "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/result.txt",
        benchmark = "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/benchmark.json"
    benchmark:
        "{RESULTS_DIR}/unary/{operation}/{library}/{genome}/{nrows}/{maxlength}/snakemake_benchmark.jsonl"
    run:
        script = f"scripts/unary/{wildcards.library}/{wildcards.operation}"
        cmd = f"Rscript {script}.R {input[0]} {output.result}"
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

rule unary_real_python:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "py"]),
        operation = "|".join(unary_operations.Operation.drop_duplicates()),
        nrows = "10_000|100_000|1_000_000|10_000_000"
    input:
        str(REAL_DOWNLOAD_DIR / "annotation/{nrows}/Homo_sapiens.GRCh38.115.bed")
    output:
        result = "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/result.txt",
        benchmark = "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/benchmark.json"
    benchmark:
        "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/snakemake_benchmark.jsonl"
    run:
        module = f"scripts.unary.{wildcards.library}.{wildcards.operation}"

        cmd = f"python -m {module} {input} {output.result}"
        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=read_sizes[wildcards.nrows],
            library=wildcards.library,
            genome="real_data",
            max_length=0,
            operation=wildcards.operation,
        )


rule unary_real_shell:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "sh"]),
        operation = "|".join(unary_operations.Operation),
        nrows = "10_000|100_000|1_000_000|10_000_000"
    input:
        str(REAL_DOWNLOAD_DIR / "annotation/{nrows}/Homo_sapiens.GRCh38.115.bed")
    output:
        result = "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/result.txt",
        benchmark = "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/benchmark.json"
    benchmark:
        "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/snakemake_benchmark.jsonl"
    run:
        script = f"scripts/unary/{wildcards.library}/{wildcards.operation}"
        write_output_cmd = f" | tail > {output.result}"
        cmd = f"bash {script}.sh {input[0]} {write_output_cmd}"

        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=read_sizes[wildcards.nrows],
            library=wildcards.library,
            genome="real_data",
            max_length=0,
            operation=wildcards.operation,
        )


rule unary_real_r:
    wildcard_constraints:
        library = "|".join([k for k, v in config["library_to_language"].items() if v == "R"]),
        operation = "|".join(unary_operations.Operation),
        nrows = "10_000|100_000|1_000_000|10_000_000"
    input:
        str(REAL_DOWNLOAD_DIR / "annotation/{nrows}/Homo_sapiens.GRCh38.115.bed"),
    output:
        result = "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/result.txt",
        benchmark = "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/benchmark.json"
    benchmark:
        "{REAL_RESULTS_DIR}/unary/{operation}/{library}/{nrows}/snakemake_benchmark.jsonl"
    run:
        script = f"scripts/unary/{wildcards.library}/{wildcards.operation}"
        cmd = f"Rscript {script}.R {input[0]} {output.result}"
        run_case(
            cmd,
            benchmark_file=output.benchmark,
            result_file=output.result,
            number_rows=read_sizes[wildcards.nrows],
            library=wildcards.library,
            genome="real_data",
            max_length=0,
            operation=wildcards.operation,
        )
