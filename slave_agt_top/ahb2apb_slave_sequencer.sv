
class ahb2apb_slave_sequencer extends uvm_sequencer #(read_xtn);


	`uvm_component_utils(ahb2apb_slave_sequencer)

	extern function new(string name="ahb2apb_slave_sequencer",uvm_component parent);

endclass

function ahb2apb_slave_sequencer::new(string name="ahb2apb_slave_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction
