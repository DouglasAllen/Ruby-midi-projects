class Spinner
  attr_reader :state
  def initialize(params={})
    params.has_key?(:slice_values) ? @slice_values =
      params[:slice_values] : @slice_values = [-1,0,1]
    if params.has_key?(:slice_sizes)
      if @slice_values.length != params[:slice_sizes].length
        puts("error: length of :slice_sizes should = :slice_values")
        @slice_sizes = []
        for slice in @slice_values
          @slice_sizes.push(1)
        end
      else
        @slice_sizes = params[:slice_sizes]
      end
    else
      @slice_sizes  = [1,1,1]
    end
    params.has_key?(:minimum) ? 
    @minimum = params[:minimum] : @minimum  = 0
    params.has_key?(:maximum) ? 
    @maximum = params[:maximum] : @maximum  = 9
    params.has_key?(:state)   ? 
      @state   = params[:state]   : @state    = (@minimum + @maximum)/2
    params.has_key?(:edge)    ? 
      @edge    = params[:edge]    : @edge     = 'bounce'
    @summed_sizes = 0
    @slice_sizes.each {|size| @summed_sizes += size}
    if @summed_sizes > 0
      for i in 1..(@slice_sizes.length.-1)
        @slice_sizes[i] += @slice_sizes[i-1]
      end
    else
      @slice_sizes[0] = 1
      @summed_sizes = 1
    end
  end
  def spin
    result = rand(@summed_sizes)
    i = 0
    until result < @slice_sizes[i]
      i += 1
    end
    @state = @state + @slice_values[i]
    if @state < @minimum
      if @edge == 'bounce'
        @state = @minimum + (@minimum - @state)
      else # 're_enter opposite'
        @state = @maximum - (@minimum - @state - 1)
      end
    elsif @state > @maximum
      if @edge == 'bounce'
        @state = @maximum - (@state - @maximum)
      else # 're_enter opposite'
        @state = @minimum + (@state - @maximum - 1)
      end
    end
    return @state
  end
end

brown_noise = Spinner.new
10.times do
  puts(brown_noise.spin)
end
