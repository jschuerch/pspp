| m r x y |m := CanvasMorph new.m openInWindowLabeled: 'Montecarlo Verfahren'."m drawBlock: [:c |c line: 10@10 to: 100@100 color: Color red.c frameOval: (50@50 extent: 20@20) color: Color red.c fillOval: (10@10 extent: 20@20) color: Color red.c frameRectangle: (60@60 extent: 30@30) color: (Color r:0.8 g:0 b:0).c fillRectangle: (20@20 extent: 30@30) color: Color blue.c drawString: 'Hello World' at: 100@100.]."m drawBlock: [ :c |	rand := Random new.	1 to: 100000 do: [: i |		x := (rand next).		y := (rand next).		r := (x squared + y squared).		x := x * 400.		y := (1-y) * 400.		r < 1			ifTrue: [c line: x@y to: x@y color: Color red]			ifFalse: [c line: x@y to: x@y color: Color black].					"c line: (x-1)@y to: (x+1)@y color: Color red.		c line: x@(y-1) to: x@(y+1) color: Color red."	]].