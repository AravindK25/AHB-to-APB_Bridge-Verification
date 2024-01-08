class ahb2apb_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

//factory registration
`uvm_component_utils(ahb2apb_virtual_sequencer)

ahb2apb_master_sequencer m_seqrh[];
ahb2apb_slave_sequencer s_seqrh[];

ahb2apb_env_config env_cfg;

extern function new(string name = "ahb2apb_virtual_sequencer",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function ahb2apb_virtual_sequencer::new(string name="ahb2apb_virtual_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction

function void ahb2apb_virtual_sequencer::build_phase(uvm_phase phase);

//get the config object ahb2apb_env_config using uvm_config_db
if(!uvm_config_db #(ahb2apb_env_config)::get(this,"","ahb2apb_env_config",env_cfg))
	`uvm_fatal("CONFIG","cannot get env_cfg from uvm_config_db.have you set it ?")
	
	super.build_phase(phase);

	m_seqrh=new[env_cfg.no_of_master_agents];
	
	s_seqrh=new[env_cfg.no_of_slave_agents];

endfunction
