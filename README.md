# DCE_dictionary_recon

Demo code for the manuscript entitled:

"Tracer Kinetic Models as Temporal Constraints during brain tumor DCE-MRI reconstruction"

Authors: Sajan Goud Lingala, Yi Guo, Yannick Bliesener, Yinghua Zhu, R. Marc Lebel, Meng Law, Krishna S. Nayak

Submitted to Medical Physics

Code usage: 

1. Download an example raw fully sampled k-space DCE-MRI dataset from: https://www.dropbox.com/s/ckxqllgtqm1cu5j/case2_kspace.mat?dl=0

2. Uncompress folders: dictionary_generation, and rocketship_fitting

3. run_invivo.m: 
  - Demonstration of invivo retrospective undersampling experiment of reconstructing DCE concentration profiles from under-sampled data
  - This demo uses the extended Tofts based dictionary - as a temporal constraint in the reconstruction
  - Other kinetic model based dictionaries can be generated; See the folder (dictionary_generation) for more details

4. dictionary_generation/run_dictionary_generation.m: 
  - This code generates a comprehensive library of all the concentration profiles from a specified range of TK parameters
  - Next, it used k-SVD to learn a smaller dictionary of basis functions from the library
  - This demo is set up with the e_Tofts model from the Rocketship tool box (Sam Barnes et al). It is flexible to adapt to other models. 
  
5. rocketship_fitting: Rocketship tool box for DCE TK model fitting courtesy Sam Barnes; BMC Medical Imaging201515:19. 
  - We use the rocketship fitting tool box for all our DCE TK model fitting




