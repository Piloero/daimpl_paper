def listing1 (x y: Nat) : Nat :=
  let z := x + y

  if x > 4 then
    /- return -/ x + y
  else
    /- return -/ z + 2

def listing1_elim (x y: Nat) : Nat :=
  let h := x + y
  let z := h

  if x > 4 then
    /- return -/ h
  else
    /- return -/ z + 2

def listing2 (x y : Nat) : (Nat × Nat) :=
  let a := x + y
  let b := x + y
  (a, b)

def listing2_elim (x y : Nat) : (Nat × Nat) :=
  let a := x + y
  let b := a
  (a, b)


-- you can play around with the numbers and see that
-- regardles of input paramers the output will be the same
def x := 10
def y := 10

#eval listing1 x y == listing1_elim x y
#eval listing2 x y == listing2_elim x y

#eval listing1 x y

-- you don't have to use this
def main : IO Unit :=
  do
    IO.println s!"listing1: {listing1 x y}"
    IO.println s!"listing1_elim {listing1_elim x y}"
