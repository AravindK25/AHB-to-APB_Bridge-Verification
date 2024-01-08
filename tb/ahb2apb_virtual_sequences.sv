class ahb2apb_vbase_seq extends uvm_sequence #(uvm_sequence_item);

//facatory registration
`uvm_object_utils(ahb2apb_vbase_seq)

ahb2apb_env_config env_cfg;

ahb2apb_single_wr_xtns single_wr_xtns;

//ahb2apb_seq_rd_xtns seq_rd_xtns;

ahb2apb_unspecified_wr_xtns unspecified_wr_xtns;

ahb2apb_inc_wr_xtns inc_wr_xtns;

ahb2apb_wrap_wr_xtns wrap_wr_xtns;

ahb2apb_virtual_sequencer v_seqrh;

ahb2apb_master_sequencer m_seqrh[];

ahb2apb_slave_sequencer s_seqrh[];


extern function new(string name="ahb2apb_vbase_seq");
extern task body();
endclass: ahb2apb_vbase_seq

function ahb2apb_vbase_seq::new(string name ="ahb2apb_vbase_seq");
	super.new(name);
endfunction

task ahb2apb_vbase_seq::body();

//get the env_config from database using uvm_config_db
	if(!uvm_config_db #(ahb2apb_env_config)::get(null,get_full_name(),"ahb2apb_env_config",env_cfg))
	`uvm_fatal("VSEQ","cannot get env_config  from uvm_config_db.have you set it?")

	m_seqrh=new[env_cfg.no_of_master_agents];
	s_seqrh=new[env_cfg.no_of_slave_agents];

assert($cast(v_seqrh,m_sequencer)) 
else 
	begin
	`uvm_error("BODY","Error in $cast of virtual sequencer")
	end

foreach(m_seqrh[i])
	m_seqrh[i]=v_seqrh.m_seqrh[i];
foreach(s_seqrh[i])
	s_seqrh[i]=v_seqrh.s_seqrh[i];
endtask:body


//single transfer virtual sequence 

class ahb2apb_single_vseq extends ahb2apb_vbase_seq;
	
	`uvm_object_utils(ahb2apb_single_vseq)

extern function new(string name= "ahb2apb_single_vseq");
extern task body();
endclass:ahb2apb_single_vseq

function ahb2apb_single_vseq::new(string name= "ahb2apb_single_vseq");
	super.new(name);
endfunction

task ahb2apb_single_vseq::body();
	super.body();
single_wr_xtns=ahb2apb_single_wr_xtns::type_id::create("single_wr_xtns");
	fork
		begin
		single_wr_xtns.start(m_seqrh[0]);
		end
		
	join

endtask

//unspecified virtual sequence 
class ahb2apb_unspecified_vseq extends ahb2apb_vbase_seq;
	
	`uvm_object_utils(ahb2apb_unspecified_vseq)

extern function new(string name= "ahb2apb_unspecified_vseq");
extern task body();	
endclass:ahb2apb_unspecified_vseq

function ahb2apb_unspecified_vseq::new(string name= "ahb2apb_unspecified_vseq");
	super.new(name);
endfunction

task ahb2apb_unspecified_vseq::body();
	super.body();
unspecified_wr_xtns=ahb2apb_unspecified_wr_xtns::type_id::create("unspecified_wr_xtns");
	fork
		begin
		unspecified_wr_xtns.start(m_seqrh[0]);
		end
	join

endtask


//inc sequence 
class ahb2apb_inc_vseq extends ahb2apb_vbase_seq;
	
	`uvm_object_utils(ahb2apb_inc_vseq)

extern function new(string name= "ahb2apb_inc_vseq");
extern task body();	
endclass:ahb2apb_inc_vseq

function ahb2apb_inc_vseq::new(string name= "ahb2apb_inc_vseq");
	super.new(name);
endfunction

task ahb2apb_inc_vseq::body();
	super.body();
inc_wr_xtns=ahb2apb_inc_wr_xtns::type_id::create("inc_wr_xtns");

	fork
		begin
		inc_wr_xtns.start(m_seqrh[0]);
		end
	join

endtask


//wrap sequence 
class ahb2apb_wrap_vseq extends ahb2apb_vbase_seq;
	
	`uvm_object_utils(ahb2apb_wrap_vseq)

extern function new(string name= "ahb2apb_wrap_vseq");
extern task body();	
endclass:ahb2apb_wrap_vseq

function ahb2apb_wrap_vseq::new(string name= "ahb2apb_wrap_vseq");
	super.new(name);
endfunction

task ahb2apb_wrap_vseq::body();
	super.body();
wrap_wr_xtns=ahb2apb_wrap_wr_xtns::type_id::create("wrap_wr_xtns");
	fork
		begin
		wrap_wr_xtns.start(m_seqrh[0]);
		end
	join

endtask


