def GPS():
  ser = serial.Serial('/dev/ttyAMA0', 19200, timeout=0) # definování portu
  s = ser.read(1000) # přečtení věty
  while (s.find($GPGGA, beg=0, end=len(s)) == -1):
    s = ser.read(1000) #
  souradnice = s.split(",") # uložení věty do pole
  return souradnice # vrácení věty v poli

def souradnice():
  veta = GPS() # zjištění věty
  sour = [veta[2], veta[3], veta[4], veta[5]] # vrátí souřadnice v pořadí: zeměpisná šířka, N (sever) nebo S (jih), zeměpisná délka, E (východ) nebo W (západ).
  retourn sour # vrácení souřadnic v poli
  
def nad_morska_vyska():
  veta = GPS() # zjištění věty
  if (veta[10] == M): # zjištění jestli je jednotka v metrech
    mnm = veta[11]
    return mnm # vrácení nadmořské výšky
