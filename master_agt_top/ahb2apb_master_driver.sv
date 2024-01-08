class ahb2apb_master_driver extends uvm_driver #(write_xtn);


	`uvm_component_utils(ahb2apb_master_driver)

	virtual ahb_if.AHB_DRV master_vif;

	int write_xtns_count;

	write_xtn xtn;

	ahb2apb_master_agent_config master_cfg;
	extern function new(string name="ahb2apb_master_driver",uvm_component parent);

	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut (write_xtn xtn);	
	extern function void report_phase(uvm_phase phase);
endclass

function ahb2apb_master_driver::new(string name="ahb2apb_master_driver", uvm_component parent);
	super.new(name,parent);
endfunction
 
function void ahb2apb_master_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(ahb2apb_master_agent_config)::get(this,"","ahb2apb_master_agent_config",master_cfg))
	`uvm_fatal("CONFIG","cannot get() master_cfg from uvnm_config_db. Have you set it?")
endfunction

function void ahb2apb_master_driver::connect_phase(uvm_phase phase);
	master_vif=master_cfg.master_vif;
endfunction



task ahb2apb_master_driver::run_phase(uvm_phase phase);


        //Active low reset
        @(master_vif.ahb_cb_drv);
        master_vif.ahb_cb_drv.Hresetn <= 1'b0;

        @(master_vif.ahb_cb_drv);
        master_vif.ahb_cb_drv.Hresetn <= 1'b1;

        forever
                begin
                        seq_item_port.get_next_item(req); //get the data from sequencer
                        send_to_dut(req);
		//	req.print();
                        seq_item_port.item_done();
                end
endtask


/*
task ahb2apb_master_driver::send_to_dut(write_xtn xtn);

	@(master_vif.ahb_cb_drv);
        master_vif.ahb_cb_drv.Hwrite  <= xtn.Hwrite;
        master_vif.ahb_cb_drv.Htrans <= xtn.Htrans;
        master_vif.ahb_cb_drv.Hsize   <= xtn.Hsize;
        master_vif.ahb_cb_drv.Haddr   <= xtn.Haddr;
        master_vif.ahb_cb_drv.Hreadyin<= 1'b1;
	master_vif.ahb_cb_drv.Hburst  <= xtn.Hburst;
		
      // 	@(master_vif.ahb_cb_drv);
	wait(master_vif.ahb_cb_drv.Hreadyout)
        //wait till Hreadyout goes high - the moment it goes high drive Hwdata
        if(master_vif.ahb_cb_drv.Hwrite)
                master_vif.ahb_cb_drv.Hwdata<=xtn.Hwdata;
	else 
		master_vif.ahb_cb_drv.Hwdata<=32'd0;
	
	`uvm_info("AHB_MASTER_DRIVER", $sformatf("printing the data from master_driver \n %s", xtn.sprint()), UVM_LOW)
	write_xtns_count++;
      // @(master_vif.ahb_cb_drv);
endtask
*/


task ahb2apb_master_driver::send_to_dut(write_xtn xtn);

        master_vif.ahb_cb_drv.Hwrite  <= xtn.Hwrite;
        master_vif.ahb_cb_drv.Htrans <= xtn.Htrans;
        master_vif.ahb_cb_drv.Hsize   <= xtn.Hsize;
        master_vif.ahb_cb_drv.Haddr   <= xtn.Haddr;
        master_vif.ahb_cb_drv.Hreadyin<= 1'b1;
	master_vif.ahb_cb_drv.Hburst  <= xtn.Hburst;
		
      	 	@(master_vif.ahb_cb_drv);

	wait(master_vif.ahb_cb_drv.Hreadyout)
	
		if(xtn.Hwrite)
                master_vif.ahb_cb_drv.Hwdata<=xtn.Hwdata;
		else
		master_vif.ahb_cb_drv.Hwdata<=32'bz;
	
	//`uvm_info("AHB_MASTER_DRIVER", $sformatf("printing the data from master_driver \n %s", xtn.sprint()), UVM_LOW)
	//write_xtns_count++;
      // @(master_vif.ahb_cb_drv);
endtask


function void ahb2apb_master_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: AHB Driver sent %0d transactions", write_xtns_count), UVM_LOW)
endfunction






















