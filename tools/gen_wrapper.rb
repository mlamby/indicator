require 'rexml/document'
require 'erb'

include REXML

# Convert a string to an underscore string
class String
  def underscore
    self.tr(" ", "_").
    gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def quoted
    '"' + self + '"'
  end
end


# Class to hold the data read in from the TA-LIB description xml.
# This is used as the data object to pass to the ERB templates.
class FinancialFunction

  attr_reader :name, :camel_name, :desc, :group_id
  attr_reader :inputs, :outputs, :arguments
  attr_reader :bar_input
  def initialize e
    bar_names = ['open', 'high', 'low', 'close']
    @name = get_text e, 'Abbreviation'
    @camel_name = get_text e, 'CamelCaseName'
    @desc = get_text e, 'ShortDescription'
    @group_id = get_text e, 'GroupId'

    @inputs = []
    @index = 0
    XPath.each(e, 'RequiredInputArguments/RequiredInputArgument') do |arg|
      @inputs << process_input(arg)
    end

    @bar_input = @inputs.any? { |i| bar_names.include? i[:name_us] }
    map_bar_inputs if @bar_input 

    @arguments = []
    @index = 0
    XPath.each(e, 'OptionalInputArguments/OptionalInputArgument') do |arg|
      @arguments << process_argument(arg)
    end
    
    @outputs = []
    @index = 0
    XPath.each(e, 'OutputArguments/OutputArgument') do |arg|
      @outputs << process_output(arg)
    end
  end

  def process_input arg
    input = {}
    t = get_text arg, 'Type'
    input[:type] = t
    input[:name] = get_text arg, 'Name' 
    input[:name_us] = input[:name].underscore
    input[:index] = @index
    @index += 1
    input 
  end

  def map_bar_inputs
    @index = 0
    lst = []
    lst << create_bar_input('open') if has_bar_input('open')
    lst << create_bar_input('high') if has_bar_input('high')
    lst << create_bar_input('low') if has_bar_input('low')
    lst << create_bar_input('close') if has_bar_input('close')
    lst << create_bar_input('volume') if has_bar_input('volume')
    @inputs = lst
  end

  def has_bar_input name
    @inputs.any? { |i| i[:name_us] == name } 
  end

  def create_bar_input name
    input = {}
    input[:type]  = 'real'
    input[:name] = name
    input[:name_us] = name
    input[:index] = @index
    @index += 1
    input
  end 

  def process_argument arg
    argument = {}
    argument[:name] = get_text arg, 'Name'
    argument[:name_us] = argument[:name].underscore
    argument[:short_desc] = get_text arg, 'ShortDescription'
    argument[:long_desc] = get_text arg, 'LongDescription'
    t = get_text arg, 'Type'
    argument[:type] = t
    argument[:setter] = t == 'Double' ? 'opt_real' : 'opt_int'
    argument[:type_convert] = t == 'Double' ? 'to_f' : 'to_i'  
    argument[:default] = get_text arg, 'DefaultValue'
    argument[:index] = @index
    @index += 1
    argument
  end

  def process_output arg
    output = {}
    t = get_text arg, 'Type'
    output[:type] = t 
    output[:setter] = t == 'Double Array' ? 'out_real' : 'out_int'
    output[:name] = get_text arg, 'Name'
    output[:name_us] = output[:name].underscore
    output[:index] = @index
    @index += 1
    output
  end

  def get_binding
    binding
  end

  def get_text e, str
    element = e.elements[str]
    element.nil? ? nil : element.text
  end
end

# Load the ta-lib xml description
file = File.new 'ta_func_api.xml'
doc = REXML::Document.new file

functions = []

# Loop over every function
XPath.each(doc, "//FinancialFunction") do |elem|
  functions << FinancialFunction.new(elem)
end

text = '' 
File.open('func_template.erb', 'r') { |fin| text = fin.read }
template = ERB.new(text,nil,'<>')

# Generate code for each function
functions.each do |f|
  f_name = "../lib/indicator/auto_gen/#{f.camel_name.underscore}.rb"
  #puts "Creating file #{f_name}"
  File.open(f_name, 'w') do |fout| 
    fout.write template.result(f.get_binding)
  end
end

# Generate a listing of all the functions
File.open('list_template.erb', 'r') { |fin| text = fin.read }
template = ERB.new(text,nil,'<>')
f_name = "../lib/indicator/auto_gen.rb"
puts "Creating file #{f_name}"
File.open(f_name, 'w') do |fout| 
  fout.write template.result(binding)
end
