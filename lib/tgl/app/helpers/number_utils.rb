#
# $Id: number_utils.rb 2 2011-01-16 01:15:24Z nicb $
#
module NumberUtils

  class CapStringOverflowError < StandardError
  end

  class <<self

  private

	  CAP_NUMBERS = [ 'ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT',
	                  'NINE', 'TEN', 'ELEVEN', 'TWELVE', 'THIRTEEN', 'FOURTEEN', 'FIFTEEN',
	                  'SIXTEEN', 'SEVENTEEN', 'EIGHTEEN', 'NINETEEN', 'TWENTY' ]
	
  public

	  def to_cap_string(number)
	    raise CapStringOverflowError("number (#{number}) can't be larger than #{CAP_NUMBERS.size}") if number > CAP_NUMBERS.size
	    return CAP_NUMBERS[number]
	  end

  end

end

class Float

  alias :int_round :round

  def round(prec = 2)
    scale = 10**prec
    scaled = self * scale
    return scaled.int_round.to_f / scale
  end


  def to_money(decs = 2)
    s = sprintf("%.*f", decs, self.round(decs))
    s.sub!(/\./, ',')
    frac = s[s.index(',')..s.size]
    integ = s[0..s.index(',')-1]
    integ_a = []
    n = 0
    (integ.size-1).downto(0) do
      |i|
      if n > 0 and (n % 3) == 0
        integ_a.unshift('.')
      end
      integ_a.unshift(integ[i..i])
      n += 1
    end
    return integ_a.join('') + frac
  end

  def to_euro
    return to_money
  end

end

class Fixnum

  def to_euro
    return self.to_f.to_euro
  end

end
