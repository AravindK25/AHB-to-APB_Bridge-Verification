class ahb2apb_master_agent extends uvm_agent;

`uvm_component_utils(ahb2apb_master_agent)

ahb2apb_master_agent_config master_cfg;

ahb2apb_master_monitor master_mon;
ahb2apb_master_sequencer master_sequencer;
ahb2apb_master_driver master_drv;


extern function new(string name="ahb2apb_master_agent",uvm_component parent =null);

extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass :ahb2apb_master_agent

function ahb2apb_master_agent::new(string name="ahb2apb_master_agent", uvm_component parent=null);
	super.new(name,parent);
endfunction

function void ahb2apb_master_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	master_mon=ahb2apb_master_monitor::type_id::create("master_mon",this);
	if(!uvm_config_db #(ahb2apb_master_agent_config)::get(this,"","ahb2apb_master_agent_config",master_cfg))
	`uvm_fatal("MASTER_CONFIG","cannot get config from uvm_config_db. have you set it?")
	if(master_cfg.is_active==UVM_ACTIVE)
	begin
	master_drv=ahb2apb_master_driver::type_id::create("master_drv",this);
	master_sequencer=ahb2apb_master_sequencer::type_id::create("master_sequencer",this);
	end
endfunction

function void ahb2apb_master_agent::connect_phase(uvm_phase phase);
	if(master_cfg.is_active==UVM_ACTIVE)
	begin
	master_drv.seq_item_port.connect(master_sequencer.seq_item_export);
	end
endfunction

