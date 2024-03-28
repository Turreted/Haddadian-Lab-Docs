## General
**Useful Resources**:
- [RCC Docs](https://rcc-uchicago.github.io/user-guide/)
- [RCC AlphaFold Page](https://rcc-uchicago.github.io/user-guide/software/apps-and-envs/alphafold/?h=alpha)
- [RCC NAMD Page](https://rcc-uchicago.github.io/user-guide/software/apps-and-envs/namd/?h=namd)

**Simulation Naming Convention**: \<Number of residues\>r.\<Number of chains\>c.\<orientation \> So for example, 42r.3c.embedded is a 42-residue abeta complex with 3 chains that is embedded in the membrane.

## Running AlphaFold simulations

RCC has alphafold v2.3.2 installed on their system, so all you need to do is provide a FASTA file and use the file provided in [alphafold/alphafold2.3-submit.sh](https://github.com/Turreted/Haddadian-Lab-Docs/blob/main/alphafold-scripts/alphafold2.3-submit.sh) to run your job. 

The template for running an AlphaFold job is:
```bash
sbatch alphafold2.3-submit.sh -f <input fasta file> -o <output dir>
```
To test that AlphaFold monomer and multimer work, run the following
```bash
sbatch alphafold2.3-submit.sh -f alphafold-scripts/tests/monomer-test.fasta -m monomer -o .
sbatch alphafold2.3-submit.sh -f alphafold-scripts/tests/multimer-test.fasta -m multimer -o .
```

## Running GaMD simulations

The outline of running a GaMD system is: (1) Build the system (2) cMD Equilibration &rarr; (3) cMD Production &rarr; (4) GaMD Equilibration &rarr; (5) GaMD production

Steps 1-3 are done for all systems, step 4 needs to be done just for the 40r.13c system, and step 5 needs to be repeated until Haddadian says enough time is passed (probably 100-200ns).

1. **Building the system:** All of the cMD equilibration and production steps have already been run. If you need to create a new system, I recommend using [CHARMM-GUI](https://www.charmm-gui.org/) and using the builtin tool to set the orientation and resolve collisions between the complex and the membrane. This can be a pain, so feel free to email me with any questions if this is something you have to do. 

2. **cMD Equilibration:** CHAARM-GUI generates all of the NAMD config files for the equilibration automatically, so you just need to run them. Since this can be tedious, the following script will automatically queue and run all of the cMD equilibration steps:
```bash
cp cmd-submission-scripts/step6.*-equilib.sh <system-name>/namd
cp cmd-submission-scripts/batch-submit.sh <system-name>/namd
cd <system-name>/namd
bash batch-submit.sh
```
 
3. **cMD Production:** This is a single 1ns NAMD job that should be run before GaMD to ensure the system is stable. 
```bash
cp cmd-submission-scripts/step7_production.sh <system-name>/namd
cd <system-name>/namd
sbatch step7_production.sh
```

4. **GaMD Equilibration:** This can take 3-4 days (depending on node allocation) and must be run as a single production run. **be sure to email RCC to ask for an extension** immediately after queuing the job - it is better to give it more time than you think you need. The NAMD config file is called ``gamd-equilib.inp`` and is contained in the ``submission-scripts`` directory. 
5. **GaMD Production:** Most of your jobs will be extending GaMD production runs. I've written a script to automate this process which you have access to simply run:
```bash
new-gamd-prod.sh <num>
sbatch gamd-prod-<num>.sh
```
Note that this script just copies the previous submission ``.sh`` and ``.inp`` files from the previous copy in the current directory, so it will not work if those files are not present, or if they are named something incorrectly. If you don't have any production scripts in the current directory, copy ``gamd-submission-scripts/gamd-prod-1.*`` to the current directory. 

**Note that simulations cannot be stopped mid-run,** so make sure you give them enough time. Email rcc if you need to extend the job, though they may take up to 24 hours to reply.

## Building Systems

### Non-membrane systems
If you just have a protein system that you need to build a simulation for, there's an excellent guide by one of Haddadian's TAs [here](https://github.com/Turreted/Haddadian-Lab-Docs/blob/main/pdfs/vmd_all_atom_system_guide.pdf) on how to do it with VMD.

### Membrane Systems
I built all the membrane systems using [CHARMM-GUI](https://charmm-gui.org/), which is an interactive online portal for building MD systems. The tricky bit is orienting the protein an membrane.
