#Makefile for UVM Testbench - Lab 06

# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS

SIMULATOR = Questa

FSDB_PATH=/home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64

RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/top.sv
INC = +incdir+../tb +incdir+../test +incdir+../source_agt_top +incdir+../dest_agt_top 
SVTB2 = ../test/router_test_pkg.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"
VSIMBATCH5= -c -do  " log -r /* ;coverage save -onexit mem_cov5;run -all; exit"
VSIMBATCH6= -c -do  " log -r /* ;coverage save -onexit mem_cov6;run -all; exit"

help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                             										!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.       								!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                   								!"
	@echo "! run_test	=>  clean, compile & run the simulation for router_base_test in batch mode.		!" 
	@echo "! run_test1	=>  clean, compile & run the simulation for small_test_0 in batch mode.			!" 
	@echo "! run_test2	=>  clean, compile & run the simulation for medium_test_0 in batch mode.			!"
	@echo "! run_test3	=>  clean, compile & run the simulation for big_test_0 in batch mode.		!" 
	@echo "! run_test4	=>  clean, compile & run the simulation for medium_soft_reset_test in batch mode.		!" 
	@echo "! run_test5	=>  clean, compile & run the simulation for error_test in batch mode.		!" 
	@echo "! view_wave1 =>  To view the waveform of router_base_test                                                    !"
	@echo "! view_wave2 =>  To view the waveform of small_test_0                                                       !" 
	@echo "! view_wave3 =>  To view the waveform of medium_test_0                                                       !" 
	@echo "! view_wave4 =>  To view the waveform of big_test_0                                                      !" 
	@echo "! view_wave5 =>  To view the waveform of medium_soft_reset_test                                                      !" 
	@echo "! view_wave6 =>  To view the waveform of error_test                                                      !" 
	@echo ====================================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
run_test1 : run_test1_$(SIMULATOR)
run_test2 : run_test2_$(SIMULATOR)
run_test3 : run_test3_$(SIMULATOR)
run_test4 : run_test4_$(SIMULATOR)
run_test5 : run_test5_$(SIMULATOR)
run_test6 : run_test6_$(SIMULATOR)
run_test7 : run_test7_$(SIMULATOR)
run_test8 : run_test8_$(SIMULATOR)
run_test9 : run_test9_$(SIMULATOR)
run_test10 : run_test10_$(SIMULATOR)
run_test11 : run_test11_$(SIMULATOR)
view_wave1 : view_wave1_$(SIMULATOR)
view_wave2 : view_wave2_$(SIMULATOR)
view_wave3 : view_wave3_$(SIMULATOR)
view_wave4 : view_wave4_$(SIMULATOR)
view_wave5 : view_wave5_$(SIMULATOR)
view_wave6 : view_wave6_$(SIMULATOR)
view_wave7 : view_wave7_$(SIMULATOR)
view_wave8 : view_wave8_$(SIMULATOR)
view_wave9 : view_wave9_$(SIMULATOR)
view_wave10 : view_wave10_$(SIMULATOR)
view_wave11 : view_wave11_$(SIMULATOR)
view_wave12 : view_wave12_$(SIMULATOR)

# ----------------------------- Start of Definitions for Mentor's Questa Specific Targets -------------------------------#

sv_cmp_Questa:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1) 	
	
run_test_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -wlf wave.wlf -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=router_base_test
	
run_test1_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave1.wlf -l test2.log  -sv_seed random  work.top +UVM_TESTNAME=small_test_2
	
run_test2_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)  -wlf wave2.wlf -l test3.log  -sv_seed random  work.top +UVM_TESTNAME=medium_test_1
	
run_test3_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4)  -wlf wave3.wlf -l test4.log  -sv_seed random  work.top +UVM_TESTNAME=big_test_0

run_test4_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH5)  -wlf wave4.wlf -l test5.log  -sv_seed random  work.top +UVM_TESTNAME=medium_soft_reset_test

run_test5_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH6)  -wlf wave5.wlf -l test6.log  -sv_seed random  work.top +UVM_TESTNAME=error_test
 
run_test6_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH7)  -wlf wave6.wlf -l test7.log  -sv_seed random  work.top +UVM_TESTNAME=small_test_1
	
run_test7_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH8)  -wlf wave7.wlf -l test8.log  -sv_seed random  work.top +UVM_TESTNAME=medium_test_1
	
run_test8_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH9)  -wlf wave8.wlf -l test9.log  -sv_seed random  work.top +UVM_TESTNAME=big_test_1
	
run_test9_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH10)  -wlf wave9.wlf -l test10.log  -sv_seed random  work.top +UVM_TESTNAME=small_test_2
	
run_test10_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH11)  -wlf wave10.wlf -l test11.log  -sv_seed random  work.top +UVM_TESTNAME=medium_test_2
	
run_test11_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH12)  -wlf wave11.wlf -l test12.log  -sv_seed random  work.top +UVM_TESTNAME=big_test_2
 
clean_Questa: 
	rm -rf transcript* *log* fcover* covhtml* mem_cov* *.wlf modelsim.ini work
	clear


view_wave1_Questa: 
	vsim -view wave.wlf

view_wave2_Questa: 
	vsim -view wave1.wlf

view_wave3_Questa: 
	vsim -view wave2.wlf

view_wave4_Questa: 
	vsim -view wave3.wlf

view_wave5_Questa: 
	vsim -view wave4.wlf

view_wave6_Questa: 
	vsim -view wave5.wlf

view_wave7_Questa: 
	vsim -view wave6.wlf

view_wave8_Questa: 
	vsim -view wave7.wlf
 
view_wave9_Questa: 
	vsim -view wave8.wlf

view_wave10_Questa: 
	vsim -view wave9.wlf

view_wave11_Questa: 
	vsim -view wave10.wlf
 
view_wave12_Questa: 
	vsim -view wave11.wlf




# ----------------------------- End of Definitions for Mentor's Questa Specific Targets -------------------------------#

# ----------------------------- Start of Definitions for Synopsys's VCS Specific Targets -------------------------------#

sv_cmp_VCS:
	vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 -kdb -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(RTL) $(INC) $(SVTB2) $(SVTB1) 
	      
run_test_VCS:	clean  sv_cmp_VCS
	./simv -a vcs.log +fsdbfile+wave.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=router_base_test
	
run_test1_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave1.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=small_test_0 	
	
run_test2_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave2.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=medium_test_0
	
run_test3_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave3.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=big_test_0

run_test4_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave4.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=medium_soft_reset_test 	

run_test5_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave5.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=error_test 

run_test6_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave6.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=small_test_1 	
	
run_test7_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave7.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=medium_test_1
	
run_test8_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave8.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=big_test_1

run_test9_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave9.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=small_test_2 	
	
run_test10_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave10.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=medium_test_2
	
run_test11_VCS: clean  sv_cmp_VCS	
	./simv -a vcs.log +fsdbfile+wave11.fsdb +ntb_random_seed_automatic +UVM_TESTNAME=big_test_2
 

	
clean_VCS:
	rm -rf simv* csrc* *.tmp *.vpd *.vdb *.key *.log *hdrs.h *.fsdb verdi*
	clear

view_wave1_VCS: 
	verdi -ssf wave.fsdb
        
view_wave2_VCS: 
	verdi -ssf wave1.fsdb

view_wave3_VCS: 
	verdi -ssf wave2.fsdb

view_wave4_VCS: 
	verdi -ssf wave3.fsdb   

view_wave5_VCS: 
	verdi -ssf wave4.fsdb  
 
view_wave6_VCS: 
	verdi -ssf wave5.fsdb 

view_wave7_VCS: 
	verdi -ssf wave6.fsdb 

view_wave8_VCS: 
	verdi -ssf wave7.fsdb 

view_wave9_VCS: 
	verdi -ssf wave8.fsdb 

view_wave10_VCS: 
	verdi -ssf wave9.fsdb 

view_wave11_VCS: 
	verdi -ssf wave10.fsdb 

view_wave12_VCS: 
	verdi -ssf wave11.fsdb 

# ----------------------------- END of Definitions for Synopsys's VCS Specific Targets -------------------------------#
