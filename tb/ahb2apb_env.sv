class ahb2apb_env extends uvm_env;

`uvm_component_utils(ahb2apb_env)

	ahb2apb_master_agt_top master_top;
	ahb2apb_slave_agt_top slave_top;

	ahb2apb_virtual_sequencer v_sequencer;
	
	ahb2apb_scoreboard sb;
	
	ahb2apb_env_config ahb2apb_env_cfg;

	extern function new(string name="ahb2apb_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass: ahb2apb_env

	function ahb2apb_env::new(string name="ahb2apb_env", uvm_component parent);
	super.new(name,parent);

	endfunction

	function void ahb2apb_env::build_phase(uvm_phase phase);

	if(!uvm_config_db #(ahb2apb_env_config)::get(this,"","ahb2apb_env_config",ahb2apb_env_cfg))
	`uvm_fatal("ahb2apb_env_config","Not able to get ahb2apb config object,have you set it?")

	if(ahb2apb_env_cfg.has_master_agent)
	begin
	master_top=ahb2apb_master_agt_top::type_id::create("master_top",this);
	end

	
	if(ahb2apb_env_cfg.has_slave_agent)
	begin
	slave_top=ahb2apb_slave_agt_top::type_id::create("slave_top",this);
	end

	super.build_phase(phase);

	
	if(ahb2apb_env_cfg.has_virtual_sequencer)
	v_sequencer=ahb2apb_virtual_sequencer::type_id::create("v_sequencer",this);

	if(ahb2apb_env_cfg.has_scoreboard)
	sb=ahb2apb_scoreboard::type_id::create("sb",this);

	endfunction


	function void ahb2apb_env::connect_phase(uvm_phase phase);
	if(ahb2apb_env_cfg.has_virtual_sequencer)begin
	if(ahb2apb_env_cfg.has_master_agent)
		foreach(master_top.master_agth[i])
		v_sequencer.m_seqrh[i]=master_top.master_agth[i].master_sequencer;
		
	if(ahb2apb_env_cfg.has_slave_agent)
		foreach(slave_top.slave_agth[i])
		v_sequencer.s_seqrh[i]=slave_top.slave_agth[i].slave_sequencer;

	if(ahb2apb_env_cfg.has_scoreboard)
		begin
		if(ahb2apb_env_cfg.has_master_agent)
		begin
		foreach(ahb2apb_env_cfg.master_cfg[i])
			begin
			master_top.master_agth[i].master_mon.monitor_port.connect(sb.wr_fifo.analysis_export);
			end
		end
		if(ahb2apb_env_cfg.has_slave_agent)
		begin
		foreach(ahb2apb_env_cfg.slave_cfg[i])
		slave_top.slave_agth[i].slave_mon.monitor_port.connect(sb.rd_fifo[i].analysis_export);
		end
		end
	
	end
	endfunction


