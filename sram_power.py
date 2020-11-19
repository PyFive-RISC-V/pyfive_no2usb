#!/usr/bin/env python3

import argparse

import opendbpy as odb


class SRAMPower:

	def __init__(self, block):
		self.block = block

		self.vn  = ['via_1600x480', 'via2_1600x480', 'via3_1600x480'] 
		self.via = [ self.block.findVia(n) for n in self.vn ]
		self.met = [ v.getTopLayer() for v in self.via ]

	def find_rails(self, net_name):
		# Find wires
		net = self.block.findNet(net_name)
		sw = net.getSWires()[0] 

		# Lowest strip Y
		rl = min([x.yMin() for x in  sw.getWires() if not x.isVia()])

		# Y for each rail

		ry = list(set([w.getViaXY()[1] for w in sw.getWires() if w.isVia() and w.getBlockVia().getName() in self.vn ]))

		return rl, ry

	def find_pin_geometry(self, inst, pin_name):
		# Find ITerm
		it = inst.findITerm(pin_name)
		if it is None:
			return

		# Find geometry on 'met4'
		mt = it.getMTerm()

		for mp in mt.getMPins():
			# Look for a 'met4' shape
			for g in mp.getGeometry():
				# If we got it, we're good
				if g.getTechLayer().getName() == 'met4':
					break
			else:
				# Try next pin
				continue

			# If we get here, we found something, look no further
			break
		else:
			# Nothing found in any pins
			return

		return g

	def process_all(self):
		for inst in block_design.getInsts():
			if 'sram' in  inst.getMaster().getName():
				self.process_one(inst)

	def process_one(self, inst):
		for pn, nn in [('vdd', 'VPWR'), ('gnd', 'VGND')]:
			self.process_pin(inst, pn, nn)

	def process_pin(self, inst, pin_name, net_name):
		# Geometry discovery
		ox, oy = inst.getOrigin()

		pg = self.find_pin_geometry(inst, pin_name)
		rl, ry = self.find_rails(net_name)

		# Find wires
		net = self.block.findNet(net_name)
		sw = net.getSWires()[0] 

		# Create rail
		odb.dbSBox_create(sw, self.met[2], ox+pg.xMin(), rl,ox+pg.xMax(), oy+pg.yMin(), "STRIPE")

		# Create vias
		x = ox + (pg.xMin()+pg.xMax()) // 2

		for y in ry:
			for v in self.via:
				odb.dbSBox_create(sw, v, x, y, "STRIPE")



parser = argparse.ArgumentParser(
		description='Extends SRAM power stripes all the way down to meet grid')

parser.add_argument('--lef', '-l',
		nargs='+',
		type=str,
		default=None,
		required=True,
		help='Input LEF file(s)')

parser.add_argument('--input-def', '-id', required=True,
		help='DEF view of the design that needs to have its instances placed')

parser.add_argument('--output-def', '-o', required=True,
		help='Output placed DEF file')


db_design = odb.dbDatabase.create()

args = parser.parse_args()
input_lef_file_names = args.lef
input_def_file_name = args.input_def
output_def_file_name = args.output_def

for lef in input_lef_file_names:
    odb.read_lef(db_design, lef)
odb.read_def(db_design, input_def_file_name)

chip_design = db_design.getChip()
block_design = chip_design.getBlock()
top_design_name = block_design.getName()
print("Design name:", top_design_name)


SRAMPower(block_design).process_all()

odb.write_def(block_design, output_def_file_name)


import sys
sys.exit(0)

import opendbpy as odb

db_design = odb.dbDatabase.create()

odb.read_lef(db_design, 'test_pwr2/tmp/floorplan/merged_unpadded.lef')
odb.read_def(db_design, 'test_pwr2/tmp/floorplan/pdn.def')

chip_design = db_design.getChip()           
block_design = chip_design.getBlock()                                                                                           
top_design_name = block_design.getName()

vias = [ block_design.findVia(n) for n in ['via_1600x480', 'via2_1600x480', 'via3_1600x480'] ]
met = [ v.getTopLayer() for v in vias ]

net = block_design.findNet('VPWR')

w = net.getSWires()[0]

odb.dbSBox_create(w, met[2], 833230, 15300, 834830, 104310, "STRIPE")
odb.write_def('/tmp/x.def')


