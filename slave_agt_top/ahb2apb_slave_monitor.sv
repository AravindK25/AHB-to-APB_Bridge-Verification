class ahb2apb_slave_monitor extends uvm_monitor;


	`uvm_component_utils(ahb2apb_slave_monitor)

	virtual apb_if.APB_MON slave_vif;

	int mon_xtns_count;
	
	ahb2apb_slave_agent_config slave_cfg;
	
	uvm_analysis_port #(read_xtn) monitor_port;
	
	extern function new(string name="ahb2apb_slave_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data;
	extern function void report_phase(uvm_phase phase);
endclass

function ahb2apb_slave_monitor::new(string name="ahb2apb_slave_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction


function void ahb2apb_slave_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db #(ahb2apb_slave_agent_config)::get(this,"","ahb2apb_slave_agent_config",slave_cfg))
	`uvm_fatal("CONFIG","cannot get() slave_configuration rom uvm_config_db.Have you set it?")
endfunction

function void ahb2apb_slave_monitor::connect_phase(uvm_phase phase);
	slave_vif=slave_cfg.slave_vif;
endfunction


//run phase
task ahb2apb_slave_monitor::run_phase(uvm_phase phase);
	forever
		begin
		collect_data();
		end
endtask

/*
task ahb2apb_slave_monitor::collect_data();

	read_xtn xtn;
	xtn=read_xtn::type_id::create("xtn");
	
	@(slave_vif.apb_cb_mon);//test

	wait(slave_vif.apb_cb_mon.Penable)
		xtn.Paddr=slave_vif.apb_cb_mon.Paddr;
		
		xtn.Pwrite=slave_vif.apb_cb_mon.Pwrite;

		xtn.Pselx=slave_vif.apb_cb_mon.Pselx;

		xtn.Penable=slave_vif.apb_cb_mon.Penable;


//	@(slave_vif.apb_cb_mon);//test


	if(slave_vif.apb_cb_mon.Pwrite)
	xtn.Pwdata=slave_vif.apb_cb_mon.Pwdata;
	else
	xtn.Prdata=slave_vif.apb_cb_mon.Prdata;

//	@(slave_vif.apb_cb_mon);//test

	monitor_port.write(xtn);

//	`uvm_info("APB_SLAVE_MONITOR", $sformatf("printing the data from slave_monitor \n %s", xtn.sprint()), UVM_LOW)

	mon_xtns_count++;
endtask

*/
task ahb2apb_slave_monitor::collect_data();

	read_xtn xtn;
	xtn=read_xtn::type_id::create("xtn");


	@(slave_vif.apb_cb_mon);
	wait(slave_vif.apb_cb_mon.Penable)

		xtn.Paddr=slave_vif.apb_cb_mon.Paddr;

		xtn.Pwrite=slave_vif.apb_cb_mon.Pwrite;

		xtn.Pselx=slave_vif.apb_cb_mon.Pselx;

		
	if(slave_vif.apb_cb_mon.Pwrite)
		xtn.Pwdata=slave_vif.apb_cb_mon.Pwdata;
	else
		xtn.Prdata=slave_vif.apb_cb_mon.Prdata;

	monitor_port.write(xtn);

endtask

function void ahb2apb_slave_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report:APB MONITOR received %0d transactions", mon_xtns_count), UVM_LOW)
endfunction














