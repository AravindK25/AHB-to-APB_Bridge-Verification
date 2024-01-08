class ahb2apb_master_agent_config extends uvm_object;

`uvm_object_utils(ahb2apb_master_agent_config)

virtual ahb_if master_vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

extern function new(string name = "ahb2apb_master_agent_config");

endclass:ahb2apb_master_agent_config

function ahb2apb_master_agent_config::new(string name = "ahb2apb_master_agent_config");
	super.new(name);
endfunction
