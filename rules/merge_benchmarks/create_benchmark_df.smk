



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
            del rowdict["input_size_mb"]
            del rowdict["resources"]
            del rowdict["params"]
            wildcards = {k: v for k, v in rowdict["wildcards"].items()}
            del wildcards["RESULTS_DIR"]
            del rowdict["wildcards"]
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
            del rowdict["input_size_mb"]
            del rowdict["resources"]
            del rowdict["params"]
            wildcards = {k: v for k, v in rowdict["wildcards"].items()}
            del wildcards["REAL_RESULTS_DIR"]
            del rowdict["wildcards"]
            rowdict |= wildcards

            rowdicts.append(rowdict)

        df = pd.DataFrame.from_records(rowdicts)
        df.to_csv(output[0], index=None)
