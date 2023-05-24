# align-dnaseq

The align dnaseq pipeline can be run with conda or docker

## Installation

#### Conda

```bash
conda env create -f env.yaml
conda activate align_dnaseq
```

#### Docker

```bash
docker pull estorrs/align_dnaseq:0.0.1
```

## Usage

Example command:

```bash
python /align-dnaseq/align_dnaseq/align_dnaseq.py --out-prefix output --cpu 40 --flowcell HFMFWDSXY --index-sequencer CCAGTAGCGT-ATGTATTGGC --known-sites known_sites.chr.vcf.gz --lane 2 --library-preparation TWCE-HT191P1-S1H1A3Y3D1_1-lib1 --platform ILLUMINA --reference GRCh38.d1.vd1.fa HT191P1-S1H1A3Y3.WXS.T CCAGTAGCGT-ATGTATTGGC_S53_L002_R1_001.fastq.gz CCAGTAGCGT-ATGTATTGGC_S53_L002_R2_001.fastq.gz
```

See compute1 section for filepaths to a reference and known sites file.

If flowcell, index-sequencer, lane, and/or library-preparation are not specified then dummy default values will be used.

General Usage

```bash
python align_dnaseq.py [-h] [--flowcell FLOWCELL] [--lane LANE] [--index-sequencer INDEX_SEQUENCER] [--library-preparation LIBRARY_PREPARATION] [--known-sites KNOWN_SITES] [--reference REFERENCE] [--platform PLATFORM] [--out-prefix OUT_PREFIX] [--cpu CPU] sample fq1 fq2
```

positional arguments:
  sample                Sample id
  fq1                   Fastq R1
  fq2                   Fastq R2

options:
  -h, --help            show this help message and exit
  --flowcell FLOWCELL   flowcell used for sequencing
  --lane LANE           sequencing lane
  --index-sequencer INDEX_SEQUENCER
                        index sequencer
  --library-preparation LIBRARY_PREPARATION
                        library prep id
  --known-sites KNOWN_SITES
                        path to known sites file
  --reference REFERENCE
                        reference fp. Also needs to be in same directory as a .dict file
  --platform PLATFORM   platform. Default is ILLUMINA
  --out-prefix OUT_PREFIX
                        output prefix for aligned and sorted bam file
  --cpu CPU             num cpus to use


## Usage with bsub on compute1

There is a known sites file at `/storage1/fs1/dinglab/Active/Projects/estorrs/pecgs_resources/dnaseq_alignment/dbsnp/00-All.chr.vcf.gz`
and a reference at `/storage1/fs1/dinglab/Active/Projects/estorrs/pecgs_resources/cnv/references/GRCh38.d1.vd1/GRCh38.d1.vd1.fa`

Before you run align dnaseq you must export the following environmental variables
```bash
export LSF_DOCKER_VOLUMES="/scratch1/fs1/dinglab:/scratch1/fs1/dinglab /storage1/fs1/dinglab:/storage1/fs1/dinglab"
export PATH=/miniconda/envs/align_dnaseq/bin:$PATH
```

Then you can run the command with bsub like the following

```bash
bsub -R "select[mem>28000] rusage[mem=28000]" -M 28000 -n 40 -G compute-dinglab -q general -a 'docker(estorrs/align_dnaseq:0.0.1)' 'python /align-dnaseq/align_dnaseq/align_dnaseq.py --out-prefix output --cpu 40 --flowcell HFMFWDSXY --index-sequencer CCAGTAGCGT-ATGTATTGGC --known-sites /storage1/fs1/dinglab/Active/Projects/estorrs/pecgs_resources/dnaseq_alignment/dbsnp/00-All.chr.vcf.gz --lane 2 --library-preparation TWCE-HT191P1-S1H1A3Y3D1_1-lib1 --platform ILLUMINA --reference /storage1/fs1/dinglab/Active/Projects/estorrs/pecgs_resources/cnv/references/GRCh38.d1.vd1/GRCh38.d1.vd1.fa HT191P1-S1H1A3Y3.WXS.T CCAGTAGCGT-ATGTATTGGC_S53_L002_R1_001.fastq.gz CCAGTAGCGT-ATGTATTGGC_S53_L002_R2_001.fastq.gz'
```
