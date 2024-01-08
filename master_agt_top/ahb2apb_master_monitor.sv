class ahb2apb_master_monitor extends uvm_monitor;

	
	`uvm_component_utils(ahb2apb_master_monitor)

	virtual ahb_if.AHB_MON master_vif;

	int mon_xtns_count;
	
	write_xtn xtn;
	
	ahb2apb_master_agent_config master_agt_cfg;
	
	uvm_analysis_port #(write_xtn) monitor_port;

	extern function new(string name="ahb2apb_master_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
        extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass

function ahb2apb_master_monitor::new(string name="ahb2apb_master_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction

function void ahb2apb_master_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db #(ahb2apb_master_agent_config)::get(this,"","ahb2apb_master_agent_config",master_agt_cfg))
	`uvm_fatal("CONFIG","cannot get() master_configuration rom uvm_config_db.Have you set it?")
endfunction

function void ahb2apb_master_monitor::connect_phase(uvm_phase phase);
	master_vif=master_agt_cfg.master_vif;
endfunction

task ahb2apb_master_monitor::run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end
endtask


/*
task ahb2apb_master_monitor::collect_data();
	write_xtn xtn;
        xtn = write_xtn::type_id::create("xtn");


        @(master_vif.ahb_cb_mon);

        wait(master_vif.ahb_cb_mon.Hreadyout && (master_vif.ahb_cb_mon.Htrans == 2'b10 || master_vif.ahb_cb_mon.Htrans == 2'b11))
         xtn.Htrans = master_vif.ahb_cb_mon.Htrans;
         xtn.Hwrite = master_vif.ahb_cb_mon.Hwrite;
         xtn.Hsize  = master_vif.ahb_cb_mon.Hsize;
         xtn.Haddr  = master_vif.ahb_cb_mon.Haddr;
         xtn.Hburst = master_vif.ahb_cb_mon.Hburst;

         //the xtn will be either NS or S, first cycle - collect addr and control info

       // @(master_vif.ahb_cb_mon);

        
        wait(master_vif.ahb_cb_mon.Hreadyout && (master_vif.ahb_cb_mon.Htrans == 2'b10 || master_vif.ahb_cb_mon.Htrans == 2'b11))
	if (master_vif.ahb_cb_mon.Hwrite == 1'b1)        
        	xtn.Hwdata = master_vif.ahb_cb_mon.Hwdata;
	else
		xtn.Hrdata = master_vif.ahb_cb_mon.Hrdata;

	 monitor_port.write(xtn);
//	`uvm_info("AHB_MASTER_MONITOR", $sformatf("printing the data from master_monitor \n %s", xtn.sprint()), UVM_LOW)
        //@(master_vif.ahb_cb_mon);
	mon_xtns_count++;
endtask

*/


task ahb2apb_master_monitor::collect_data();
	write_xtn xtn;
        xtn = write_xtn::type_id::create("xtn");

        wait((master_vif.ahb_cb_mon.Htrans == 2'b10) || (master_vif.ahb_cb_mon.Htrans == 2'b11))
         xtn.Htrans = master_vif.ahb_cb_mon.Htrans;
         xtn.Hwrite = master_vif.ahb_cb_mon.Hwrite;
         xtn.Hsize  = master_vif.ahb_cb_mon.Hsize;
         xtn.Haddr  = master_vif.ahb_cb_mon.Haddr;
         xtn.Hburst = master_vif.ahb_cb_mon.Hburst;



	@(master_vif.ahb_cb_mon);

        wait(master_vif.ahb_cb_mon.Hreadyout)

		if(!master_vif.ahb_cb_mon.Hwrite)
		xtn.Hrdata = master_vif.ahb_cb_mon.Hrdata;
		
		if(master_vif.ahb_cb_mon.Hwrite)
        	xtn.Hwdata = master_vif.ahb_cb_mon.Hwdata;

		monitor_port.write(xtn);
/*		else
		if(!master_vif.ahb_cb_mon.Hwrite)
		begin
		xtn.Hrdata = master_vif.ahb_cb_mon.Hrdata;
		end*/

	 //monitor_port.write(xtn);

endtask

function void ahb2apb_master_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report:AHB MONITOR received %0d transactions", mon_xtns_count), UVM_LOW)
endfunction







