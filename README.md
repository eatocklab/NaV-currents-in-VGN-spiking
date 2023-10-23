# NaV-currents-in-VGN-spiking

Contains code associated with Baeza-Loya and Eatock, 2023 (submitted); this includes code for our Hodgkin-Huxley model with extended sodium currents, for vestibular ganglion neuron spiking, voltage clamp models of multiple voltage-gated sodium currents, and minor scripts for statistical analysis and EPSC fitting.

To run the spiking (current clamp) simulation, use Single_Compartment_Annotated as top level code in VGN_Model_New_Sodium folder.

To run the voltage clamp simulation of transient, persistent and resurgent currents, use a_Voltage_clamp_primary as the top level code from NaV_Current_VC_Sims folder.

### Acknowledgements 
Original VGN HH model code was graciously shared by R. Kalluri and can be found in the location indicated in Ventura and Kalluri, 2018 (https://doi.org/10.1523/JNEUROSCI.1811-18.2019) and Hight and Kalluri, 2016 (https://doi.org/10.1152/jn.00107.2016). 

Voltage-gated sodium current code was based on Venugopal et al., 2019 (https://doi.org/10.1371/journal.pcbi.1007154) and Rothman and Manis, 2003 (https://doi.org/10.1152/jn.00127.2002). 