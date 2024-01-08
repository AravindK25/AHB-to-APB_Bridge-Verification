class read_xtn extends uvm_sequence_item;

	`uvm_object_utils(read_xtn)

	logic Penable,Pwrite;
	
	rand logic [31:0]Prdata;

	logic [31:0]Pwdata;

	logic [31:0] Paddr;

	logic Pselx;

	//constraint Pselx_count{Pselx dist {4'b0001:=4, 4'b0010:=4, 4'b0100:=4, 4'b1000:=4};}

extern function void do_print(uvm_printer printer);
extern function new(string name = "read_xtn");
endclass:read_xtn

function read_xtn::new(string name = "read_xtn");
	super.new(name);
endfunction:new

function void read_xtn::do_print(uvm_printer printer);
super.do_print(printer);
printer.print_field("Paddr",this.Paddr,32,UVM_HEX);
printer.print_field("Penable",this.Penable,1,UVM_DEC);
printer.print_field("Pwrite",this.Pwrite,1,UVM_DEC);
printer.print_field("Pselx",this.Pselx,1,UVM_DEC);
printer.print_field("Prdata",this.Prdata,32,UVM_HEX);
printer.print_field("Pwdata",this.Pwdata,32,UVM_HEX);

endfunction
