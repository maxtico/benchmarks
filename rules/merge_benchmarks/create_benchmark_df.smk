



rule create_benchmark_df_sim:
    input:
        files_to_create_sim
    output:
        "{RESULTS_DIR}/collected_results.csv"
    run:
        rowdicts = []
        for f in input:
            f = Path(f).parent / "snakemake_benchmark.jsonl"
            rowdict = json.loads(f.read_text())
            rowdict.pop("input_size_mb", None)
            rowdict.pop("resources", None)
            rowdict.pop("params", None)
            wildcards = {k: v for k, v in rowdict.pop("wildcards", {}).items()}
            wildcards.pop("RESULTS_DIR", None)
            rowdict |= wildcards

            rowdicts.append(rowdict)

        df = pd.DataFrame.from_records(rowdicts)
        df.to_csv(output[0], index=None)


rule create_benchmark_df_real:
    input:
        files_to_create_real
    output:
        REAL_RESULTS_DIR / "collected_results.csv"
    run:
        rowdicts = []
        for f in input:
            f = Path(f).parent / "snakemake_benchmark.jsonl"
            rowdict = json.loads(f.read_text())
            rowdict.pop("input_size_mb", None)
            rowdict.pop("resources", None)
            rowdict.pop("params", None)
            wildcards = {k: v for k, v in rowdict.pop("wildcards", {}).items()}
            wildcards.pop("REAL_RESULTS_DIR", None)
            rowdict |= wildcards

            rowdicts.append(rowdict)

        df = pd.DataFrame.from_records(rowdicts)
        df.to_csv(output[0], index=None)
