class ahb2apb_master_sequencer extends uvm_sequencer #(write_xtn);


	`uvm_component_utils(ahb2apb_master_sequencer)

	extern function new(string name="ahb2apb_master_sequencer",uvm_component parent);

endclass

function ahb2apb_master_sequencer::new(string name="ahb2apb_master_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction
