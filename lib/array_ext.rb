class Array

  def order_by(order)
    attribute, direction = order.first

    self.sort{ |a,b|
      sa, sb = a.send(attribute.to_sym).to_s, b.send(attribute.to_sym).to_s
      if ((sa.downcase <=> sb.downcase) == 0)
      then sa <=> sb
      else
        na, nb = self.class.check_regexp(sa, sb)
        na <=> nb
      end
    }.tap do |items|
      items.reverse! if direction.to_sym == :desc
    end
  end

  private
  # TODO : Puts in a gem this development 
  def self.check_regexp(sa, sb)
    regexp = /(^|\D+)(\d+|(\D$))/
    ma, mb = multireg(regexp,sa), self.multireg(regexp,sb)
    it = 0
    equal = 0
    ret = ["",""]
    numeric = /(\d+)/
    while (it < [ma.size,mb.size].min) and (equal==0) 
      if (ma[it] and mb[it]) and (ma[it][1] and mb[it][1]) \
        and (numeric.match ma[it][0] and numeric.match mb[it][0])
        l = [ma[it][2].size,mb[it][2].size].max
        ret = [self.format(ma[it], l), self.format(mb[it], l)]
      else 
        ret = [ma[it][0].downcase, mb[it][0].downcase]
      end
      equal = ret[0] <=> ret[1]
      it+=1
    end
    return ret[0], ret[1]
  end

  def self.multireg rgpx, str
    result = []
    while rgpx.match str
      result.push rgpx.match(str)
      str = rgpx.match(str).post_match
    end
    result
  end

  def self.format(match_data, length)
    match_data[1].gsub("_", "").downcase + ("%0#{length}d" % match_data[2].to_i)
  end
end
