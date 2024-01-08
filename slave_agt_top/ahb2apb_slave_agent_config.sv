class ahb2apb_slave_agent_config extends uvm_object;

`uvm_object_utils(ahb2apb_slave_agent_config)

int no_of_slave_agents;

virtual apb_if slave_vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

extern function new(string name = "ahb2apb_slave_agent_config");

endclass:ahb2apb_slave_agent_config

function ahb2apb_slave_agent_config::new(string name = "ahb2apb_slave_agent_config");
	super.new(name);
endfunction
