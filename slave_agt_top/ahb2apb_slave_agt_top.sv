class ahb2apb_slave_agt_top extends uvm_env;

	`uvm_component_utils(ahb2apb_slave_agt_top)
	
	ahb2apb_env_config ahb2apb_env_cfg;
	ahb2apb_slave_agent slave_agth[];

	extern function new(string name = "ahb2apb_slave_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass:ahb2apb_slave_agt_top

	function ahb2apb_slave_agt_top::new(string name="ahb2apb_slave_agt_top",uvm_component parent);

	super.new(name,parent);
	endfunction

	function void ahb2apb_slave_agt_top::build_phase(uvm_phase phase);
	
	if(!uvm_config_db #(ahb2apb_env_config)::get(this,"","ahb2apb_env_config",ahb2apb_env_cfg))
	`uvm_fatal("ENV_CONFIG", "cannot get env_config.have you set it?")

	if(ahb2apb_env_cfg.has_slave_agent)
	begin
	slave_agth=new[ahb2apb_env_cfg.no_of_slave_agents];
	foreach(slave_agth[i])
	begin
	uvm_config_db #(ahb2apb_slave_agent_config)::set(this,"*","ahb2apb_slave_agent_config",ahb2apb_env_cfg.slave_cfg[i]);
	slave_agth[i]=ahb2apb_slave_agent::type_id::create($sformatf("slave_agth[%0d]",i),this);
	end
	end
	super.build_phase(phase);
	endfunction
