class write_xtn extends uvm_sequence_item;

	`uvm_object_utils(write_xtn)

	logic Hclock,Hresetn;//clock and resetn
	rand logic Hwrite;//write signal-master
	rand logic [2:0]Hsize;//transfer_size-master
	rand logic [1:0]Htrans;//transfer_type-master
	logic Hreadyin;//transfer done indicator-slave
	logic Hreadyout;//transfer done indicator-slave
	rand logic [31:0]Haddr;//address
	rand logic [2:0]Hburst;//burst_type-master
	logic [1:0]Hresp;//transfer_resp-slave
	rand logic [31:0]Hwdata;//write_data_bus-master
	logic [31:0]Hrdata;
	rand logic [9:0]length;

constraint valid_size {Hsize inside {[0:2]};}

constraint valid_length {(2**Hsize) * length <= 1024;}//valid length should not cross 1024(1kb)

constraint valid_haddr1 {Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
                                               [32'h8400_0000 : 32'h8400_03ff],
                                               [32'h8800_0000 : 32'h8800_03ff],
                                               [32'h8c00_0000 : 32'h8c00_03ff]};}


constraint valid_haddr {Hsize == 0 -> Haddr % 1 == 0;
			Hsize == 1 -> Haddr % 2 == 0;
                        Hsize == 2 -> Haddr % 4 == 0;}

extern function new(string name="write_xtn");
extern function void do_print(uvm_printer printer);

endclass: write_xtn

function write_xtn::new(string name="write_xtn");
	super.new(name);
endfunction

function void write_xtn::do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("Haddr", this.Haddr, 32, UVM_HEX);
        printer.print_field("Hwdata", this.Hwdata, 32, UVM_HEX);
        printer.print_field("Hwrite", this.Hwrite, 1, UVM_DEC);
        printer.print_field("Htrans", this.Htrans, 2, UVM_DEC);
	printer.print_field("Hsize", this.Hsize, 3, UVM_DEC);
	printer.print_field("Hburst", this.Hburst, 3, UVM_DEC);
	printer.print_field("Hrdata", this.Hrdata, 32, UVM_HEX);
	//printer.print_field("Hresp", this.Hresp, 2, UVM_BIN);
//	printer.print_field("Hreadyin", this.Hreadyin, 1, UVM_BIN);
	//printer.print_field("Hreadyout", this.Hreadyout, 1, UVM_BIN);

endfunction 
