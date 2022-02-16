arguments:
- position: 0
  prefix: --out-prefix
  valueFrom: output
baseCommand:
- python
- /align-dnaseq/align_dnaseq/align_dnaseq.py
class: CommandLineTool
cwlVersion: v1.0
id: align_dnaseq
inputs:
- id: sample
  inputBinding:
    position: '1'
  type: string
- id: fq_1
  inputBinding:
    position: '2'
  type: File
- id: fq_2
  inputBinding:
    position: '3'
  type: File
- id: flowcell
  inputBinding:
    position: '0'
    prefix: --flowcell
  type: string
- id: lane
  inputBinding:
    position: '0'
    prefix: --lane
  type: string
- id: index_sequencer
  inputBinding:
    position: '0'
    prefix: --index-sequencer
  type: string
- id: library_preparation
  inputBinding:
    position: '0'
    prefix: --library-preparation
  type: string
- id: platform
  inputBinding:
    position: '0'
    prefix: --platform
  type: string
- id: known_sites
  inputBinding:
    position: '0'
    prefix: --known-sites
  secondaryFiles:
  - .tbi
  type: File
- id: reference
  inputBinding:
    position: '0'
    prefix: --reference
  secondaryFiles:
  - .amb
  - .ann
  - .bwt
  - .fai
  - .pac
  - .sa
  - ^.dict
  type: File
- id: cpu
  inputBinding:
    position: '0'
    prefix: --cpu
  type: string
- default: /miniconda/envs/align_dnaseq/bin:$PATH
  id: environ_PATH
  type: string?
label: align_dnaseq
outputs:
- id: output_bam
  outputBinding:
    glob: output.bam
  secondaryFiles:
  - ^.bai
  type: File
requirements:
- class: DockerRequirement
  dockerPull: estorrs/align_dnaseq:0.0.1
- class: ResourceRequirement
  coresMin: $(inputs.cpu)
  ramMin: 28000
- class: EnvVarRequirement
  envDef:
    PATH: $(inputs.environ_PATH)
