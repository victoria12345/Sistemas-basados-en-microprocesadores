all: p4a.com p4c.exe P4B.EXE

p4a.com: p4a.obj
    tlink /v /t p4a
p4a.obj: p4a.asm 
 tasm /zi p4a.asm ,, p4a.lst
 
p4c.exe: p4c.obj
 tlink /v p4c
p4c.obj: p4c.asm 
 tasm /zi p4c.asm
 
p4b.exe: p4b.obj
 tlink /v p4b
p4b.obj: p4b.asm 
 tasm /zi p4b.asm
 
clean:
	del *.obj
	del *.exe
	del *.lst
	del *.map
	del *.COM