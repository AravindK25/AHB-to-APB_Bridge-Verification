class ahb2apb_slave_driver extends uvm_driver #(read_xtn);


	`uvm_component_utils(ahb2apb_slave_driver)
	
	virtual apb_if.APB_DRV slave_vif;

	int write_xtns_count;

	ahb2apb_slave_agent_config slave_cfg;

	extern function new(string name="ahb2apb_slave_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase);
	extern task send_to_dut(read_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass

function ahb2apb_slave_driver::new(string name="ahb2apb_slave_driver", uvm_component parent);
	super.new(name,parent);
endfunction


function void ahb2apb_slave_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(ahb2apb_slave_agent_config)::get(this,"","ahb2apb_slave_agent_config",slave_cfg))
	`uvm_fatal("CONFIG","cannot get() slave_cfg from uvnm_config_db. Have you set it?")
endfunction


function void ahb2apb_slave_driver::connect_phase(uvm_phase phase);
	slave_vif=slave_cfg.slave_vif;
endfunction


task  ahb2apb_slave_driver::run_phase(uvm_phase phase);
	req=read_xtn::type_id::create("req",this);
forever
	begin
//		seq_item_port.get_next_item(req);
		send_to_dut(req);
//		seq_item_port.item_done();
	end
endtask

/*
task ahb2apb_slave_driver::send_to_dut(read_xtn xtn);

//	 @(slave_vif.apb_cb_drv);
	wait(slave_vif.apb_cb_drv.Pselx!=0);//wait for psel to be high

	if(slave_vif.apb_cb_drv.Pwrite==0)
		slave_vif.apb_cb_drv.Prdata<=$random;
	else
		slave_vif.apb_cb_drv.Prdata<=32'd0;

	wait(slave_vif.apb_cb_drv.Penable)
	repeat(2)@(slave_vif.apb_cb_drv);

	write_xtns_count++;
//	repeat(2) @(slave_vif.apb_cb_drv);
endtask
*/


task ahb2apb_slave_driver::send_to_dut(read_xtn xtn);


//	 @(slave_vif.apb_cb_drv);
	wait(slave_vif.apb_cb_drv.Pselx!=0);//wait for psel to be high

	if(slave_vif.apb_cb_drv.Pwrite==0)
		slave_vif.apb_cb_drv.Prdata<=$random;
	else
		slave_vif.apb_cb_drv.Prdata<=32'b0;

	wait(slave_vif.apb_cb_drv.Penable)
	@(slave_vif.apb_cb_drv);

endtask

function void ahb2apb_slave_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: APB Driver sent %0d transactions", write_xtns_count), UVM_LOW)
endfunction




















