import csv
import pathlib

def summaries(wildcards):

    with checkpoints.needs_text.get(**wildcards).output[0].open() as f:
        reader = csv.DictReader(f)
        file_name = [
            row["url"].split("/")[-1]
            for row in reader
        ]

    return expand("summaries/{file_name}.summary", file_name=file_name)


rule all:
    input: summaries


checkpoint needs_text:
    output: "needs_text.csv"
    input: "summaries.csv"
    shell:
        """
        psql $DATABASE_URL -f scripts/needs_text.sql | \
            python scripts/filter_finished.py summaries.csv > {output}
        """

rule summarize:
    output: "summaries/{source_name}.summary"
    input: "{source_name}.txt"
    resources:
        threads=1
    shell:
        """
	ttok < {input} -t 500 | llm -m 3.5 -s "Summarize this legislation in 30 words" > {output}
        """

rule to_text_docx:
    output: "{source_name}.txt"
    input: "{source_name}"
    wildcard_constraints:
        source_name="[a-z0-9-]+\.docx"
    shell:
        """
        pandoc -i {input} -t plain > {output}
        """


def aggregate_texts(wildcards):

    image_directory = pathlib.Path(checkpoints.to_images.get(**wildcards).output[0])
    files = expand(
        f"text/{wildcards.source_name}/page-{{page_num}}.txt",
        page_num=glob_wildcards(image_directory / "page-{page_num}.ppm").page_num,
    )
    return sorted(files)[:10]

        
rule to_text_pdf:
    output: "{source_name}.txt"
    input: aggregate_texts
    wildcard_constraints:
        source_name="[a-z0-9-]+\.(pdf|PDF)"
    shell:
        """
        cat {input} > {output}
        """

rule tesseract:
    output: "text/{source_name}/page-{page_num}.txt"
    input: "images/{source_name}/page-{page_num}.ppm"
    shell:
        """
        mkdir -p text/{wildcards.source_name}
        tesseract -l eng --dpi 150 {input} text/{wildcards.source_name}/page-{wildcards.page_num} txt
        """

checkpoint to_images:
    output: directory("images/{source_name}/")
    input: "{source_name}"
    wildcard_constraints:
        source_name="[a-z0-9-]+\.(pdf|PDF)"
    shell:
        """
        mkdir {output}
        pdftoppm -r 150 {input} {output}/page
        """
        
rule download_pdf:
    output: "{source_name}"
    wildcard_constraints:
        source_name="[a-z0-9-]+\.(pdf|PDF|docx)"
    shell:
        """
        wget "https://occprodstoragev1.blob.core.usgovcloudapi.net/matterattachmentspublic/{output}"
        """



