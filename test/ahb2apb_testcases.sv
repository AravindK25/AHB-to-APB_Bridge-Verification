class ahb2apb_base_test extends uvm_test;

//factory registration
`uvm_component_utils(ahb2apb_base_test)

//Handles for env & env_cfg
ahb2apb_env ahb2apb_envh;
ahb2apb_env_config ahb2apb_env_cfg;

//declare dynamic array for ahb2apb_master_agent_config and ahb2apb_slave_agent_config
ahb2apb_master_agent_config  master_cfg[];
ahb2apb_slave_agent_config slave_cfg[];

//declare no_of_master_agent,no_of_slave_agent,has_master_agent,has_slave_agent,has_scoreboard

	int no_of_master_agents=1;
	int no_of_slave_agents=1;
	bit has_master_agent=1;
	bit has_slave_agent=1;
	bit has_scoreboard=1;
	bit has_virtual_sequencer=1;

//METHODS

//Standard UVM Methods:
	extern function new(string name = "ahb2apb_base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	endclass


//Define constructor new() function
	function ahb2apb_base_test::new(string name = "ahb2apb_base_test" , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void ahb2apb_base_test::build_phase(uvm_phase phase);
//create environment config object
	ahb2apb_env_cfg=ahb2apb_env_config::type_id::create("ahb2apb_env_cfg");
	
	if(has_master_agent)
			begin
		master_cfg=new[no_of_master_agents];
		ahb2apb_env_cfg.master_cfg=new[no_of_master_agents];
		foreach(master_cfg[i])
		begin
		master_cfg[i]=ahb2apb_master_agent_config::type_id::create($sformatf("master_cfg[%0d]",i));
		
		master_cfg[i].is_active=UVM_ACTIVE;
			
		if(!uvm_config_db #(virtual ahb_if)::get(this,"",$sformatf("master_vif_%0d",i),master_cfg[i].master_vif))
		`uvm_fatal("ahb2apb_Base_Test","Unable to get master_interface,Have you set it?")

		ahb2apb_env_cfg.master_cfg[i]=master_cfg[i];
		end
			end


	if(has_slave_agent)
			begin
		slave_cfg=new[no_of_slave_agents];
		ahb2apb_env_cfg.slave_cfg=new[no_of_slave_agents];
		foreach(slave_cfg[i])
		begin
		slave_cfg[i]=ahb2apb_slave_agent_config::type_id::create($sformatf("slave_cfg[%0d]",i));
		
		slave_cfg[i].is_active=UVM_ACTIVE;

		if(!uvm_config_db #(virtual apb_if)::get(this,"",$sformatf("slave_vif_%0d",i),slave_cfg[i].slave_vif))
		`uvm_fatal("ahb2apb_Base_Test","Unable to get slave_interface,Have you set it?")
	

		ahb2apb_env_cfg.slave_cfg[i]=slave_cfg[i];
		end
			end

	ahb2apb_env_cfg.no_of_master_agents=no_of_master_agents;
	ahb2apb_env_cfg.no_of_slave_agents=no_of_slave_agents;
	ahb2apb_env_cfg.has_master_agent=has_master_agent;
	ahb2apb_env_cfg.has_slave_agent=has_slave_agent;
	ahb2apb_env_cfg.has_scoreboard=has_scoreboard;	
	ahb2apb_env_cfg.has_virtual_sequencer=has_virtual_sequencer;

	uvm_config_db #(ahb2apb_env_config)::set(this,"*","ahb2apb_env_config", ahb2apb_env_cfg);

		super.build_phase(phase);

		ahb2apb_envh=ahb2apb_env::type_id::create("ahb2apb_envh", this);
	endfunction

	function void ahb2apb_base_test::end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology;
		super.end_of_elaboration_phase(phase);
	endfunction


//single transfer write test

class single_write_test extends ahb2apb_base_test;

//factory registration
`uvm_component_utils(single_write_test)

ahb2apb_single_vseq single_vseq;

//standard UVM methods
extern function new(string name= "single_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function single_write_test::new(string name="single_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void single_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task single_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	single_vseq=ahb2apb_single_vseq::type_id::create("single_vseq");

	single_vseq.start(ahb2apb_envh.v_sequencer);

	phase.drop_objection(this);
endtask



//unspecified length transfer write test

class unspecified_write_test extends ahb2apb_base_test;

//factory registration
`uvm_component_utils(unspecified_write_test)

ahb2apb_unspecified_vseq unspecified_vseq;

//standard UVM methods
extern function new(string name= "unspecified_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function unspecified_write_test::new(string name="unspecified_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void unspecified_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task unspecified_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	unspecified_vseq=ahb2apb_unspecified_vseq::type_id::create("unspecified_vseq");

	unspecified_vseq.start(ahb2apb_envh.v_sequencer);

	phase.drop_objection(this);
endtask



//increment transfer write test

class inc_write_test extends ahb2apb_base_test;

//factory registration
`uvm_component_utils(inc_write_test)

ahb2apb_inc_vseq inc_vseq;

//standard UVM methods
extern function new(string name= "inc_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function inc_write_test::new(string name="inc_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void inc_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task inc_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	inc_vseq=ahb2apb_inc_vseq::type_id::create("inc_vseq");

	inc_vseq.start(ahb2apb_envh.v_sequencer);

	phase.drop_objection(this);
endtask


//wrap transfer write test

class wrap_write_test extends ahb2apb_base_test;

//factory registration
`uvm_component_utils(wrap_write_test)

ahb2apb_wrap_vseq wrap_vseq;

//standard UVM methods
extern function new(string name= "wrap_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function wrap_write_test::new(string name="wrap_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void wrap_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task wrap_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	wrap_vseq=ahb2apb_wrap_vseq::type_id::create("wrap_vseq");

	wrap_vseq.start(ahb2apb_envh.v_sequencer);

	phase.drop_objection(this);
endtask




