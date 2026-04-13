
rule download_real_annotation:
    output:
        str(REAL_DOWNLOAD_DIR / "annotation/Homo_sapiens.GRCh38.115.bed")
    shell:
        "mkdir -p $(dirname {output}) && curl -L -o {output} https://zenodo.org/records/19481358/files/Homo_sapiens.GRCh38.115.bed"

rule download_real_hg38_reads:
    output:
        str(REAL_DOWNLOAD_DIR / "reads/hg38/HG00133.hg38.bed")
    shell:
        "mkdir -p $(dirname {output}) && curl -L -o {output} https://zenodo.org/records/19481358/files/HG00133.hg38.bed"

rule download_real_proteome_reads:
    output:
        str(REAL_DOWNLOAD_DIR / "reads/proteome/all_proteome.bed")
    shell:
        "mkdir -p $(dirname {output}) && curl -L -o {output} https://zenodo.org/records/19481358/files/all_proteome.bed"

rule subset_real_reads:
    input:
        raw = lambda wildcards: str(REAL_DOWNLOAD_DIR / f"reads/{wildcards.genome}/{wildcards.readfile}")
    output:
        str(REAL_DOWNLOAD_DIR / "reads/{genome}/{nrows}/{readfile}")
    wildcard_constraints:
        genome = "hg38|proteome",
        nrows = "10_000|100_000|1_000_000|10_000_000",
        readfile = "HG00133.hg38.bed|all_proteome.bed"
    run:
        import pyranges1 as pr

        sizes = {"10_000": 10_000, "100_000": 100_000, "1_000_000": 1_000_000, "10_000_000": 10_000_000}
        nrows = sizes[wildcards.nrows]

        df = pr.read_bed(input.raw)
        df = df.iloc[:nrows, :3]
        df = df.astype(str)
        df.to_csv(output[0], index=False, sep="\t", header=False)

rule subset_real_annotation:
    input:
        raw = lambda wildcards: str(REAL_DOWNLOAD_DIR / f"annotation/{wildcards.readfile}")
    output:
        str(REAL_DOWNLOAD_DIR / "annotation/{nrows}/{readfile}")
    wildcard_constraints:
        nrows = "10_000|100_000|1_000_000|10_000_000",
        readfile = "Homo_sapiens.GRCh38.115.bed"
    run:
        import pyranges1 as pr

        sizes = {"10_000": 10_000, "100_000": 100_000, "1_000_000": 1_000_000, "10_000_000": 10_000_000}
        nrows = sizes[wildcards.nrows]

        df = pr.read_bed(input.raw)
        df = df.iloc[:nrows, :3]
        df = df.astype(str)
        df.to_csv(output[0], index=False, sep="\t", header=False)