class ahb2apb_sbase_seq extends uvm_sequence #(read_xtn);

	`uvm_object_utils(ahb2apb_sbase_seq)

	
//standard UVM methods
	extern function new(string name= "ahb2apb_sbase_seq");
endclass

function ahb2apb_sbase_seq::new(string name= "ahb2apb_sbase_seq");
	super.new(name);
endfunction


class ahb2apb_seq_rd_xtns extends ahb2apb_sbase_seq;

	`uvm_object_utils(ahb2apb_seq_rd_xtns)

extern function new(string name= "ahb2apb_seq_rd_xtns");
extern task body();
endclass

function ahb2apb_seq_rd_xtns::new(string name= "ahb2apb_seq_rd_xtns");
	super.new(name);
endfunction

task ahb2apb_seq_rd_xtns::body();

	req=read_xtn::type_id::create("req");
	start_item(req);
	assert (req.randomize());
	finish_item(req);
endtask
