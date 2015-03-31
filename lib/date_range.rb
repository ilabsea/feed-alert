class DateRange
  include ActiveModel::Serialization
  def initialize from, to
    @from = from
    @to   = to
  end

  def from
    @from
  end

  def to
    @to
  end

  def attributes
    {from: from, to: to}
  end

end