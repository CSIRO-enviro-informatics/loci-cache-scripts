#!/bin/env python3
# -*- coding: utf-8 -*-

import csv
import sys

def get_gnaf_addr_id(uri):
    code = uri.split('/')[-1]
    return code

def get_geof_cc_id(hydroid):
    return hydroid


mb_sf_within_template = """\
:gw{within_iter:d} s: g:{addr_code:s} ;
 p: w: ;
 o: c:{hydroid:s} ;
 i: l: ;
 m: si: .

"""

infile_name = sys.argv[1]
outfile_name = sys.argv[2]

def main():
    with open(infile_name) as csv1:
        rdr = csv.reader(csv1, delimiter=',')
        header = next(rdr)
        with open(outfile_name, "w") as outfile:
            for record in rdr:
                id1 = int(str(record[0]))
                gnaf_addr = get_gnaf_addr_id(str(record[1]))
                hydroid = get_geof_cc_id(str(record[2]))
                next_chunk = mb_sf_within_template.format(addr_code=gnaf_addr, hydroid=hydroid, within_iter=id1)
                outfile.write(next_chunk)


if __name__ == "__main__":
    main()