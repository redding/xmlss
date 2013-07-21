# Xmlss
A ruby DSL for generating spreadsheets in the XML Spreadsheet format.  It provides an api for constructing spreadsheet data and then uses that data to generate xml that can be interpreted by MS Excel.

** Note: this gem only generates XML according to a subset of the August 2001 XML Spreadsheet spec (http://msdn.microsoft.com/en-us/library/aa140066(office.10).aspx).  It does not generate the more modern open office spreadsheet spec (xlsx) and may have limited support in modern spreadsheet applications.

## Simple Usage Example

```ruby
require 'xmlss'

workbook = Xmlss::Workbook.new(Xmlss::Writer.new) do

  worksheet("5 columns, 1 row") {
    5.times do
      column
    end

      row {
        # put data into the row (infer type)
        [1, "text", 123.45, "0001267", "$45.23"].each do |data_value|
          cell { data data_value }
        end
      }
    end
  }

end

workbook.to_s    # => "..." (XML Spreadsheet xml string)
```

## DSL / API

Use these directives to create workbook markup elements.

worksheet(name):
* name: string

column(apts={}):
* opts[:style_id]: string
* opts[:width]: numeric
* opts[:auto_fit_width]: bool, default: false
* opts[:hidden]: bool, default: false

row(opts={}):
* opts[:style_id]: string
* opts[:height]: numeric
* opts[:auto_fit_height]: bool, default: false
* opts[:hidden]: bool, default: false

cell(opts={}):
* opts[:style_id]: string
* opts[:href]: string
* opts[:formula]: string
* opts[:merge_across]: fixnum, default: 0
* opts[:merge_down]: fixnum, default: 0

data(value, opts={}):
* value: whatever
* opts[:type]: enum: :number, :date_time, :boolean, :string, :error
* the :type option is defaulted appropriately based on the value - use the option to override as necessary

Use these directives to define markup element styles.  Bind to markup using the element's :style_id option.  See 'examples/styles.rb' for more details.

style(id):
* id: string, must be unique to the workbook

alignment(opts={}):
* opts[:wrap_text]: bool, default: false
* opts[:rotate]: fixnum (-90 to 90)
* opts[:horizontal]: enum: :automatic, :left, :center, :right, :default
* opts[:vertical]: enum: :automatic, :top, :center, :bottom, :default

borders:
* use this to build a set of border directives (see examples/styles.rb for details)

border(opts={}):
* opts[:color]: string, hex value ('#00FF00')
* opts[:position]: enum: :left, :top, :right, :bottom
* opts[:style]: enum: :none, :continuous (default), :dash, :dot, :dash_dot, :dash_dot_dot
* opts[:weight]: enum: :hairline, :thin (default), :medium, :thick

font(opts={}):
* opts[:bold]: bool, default: false
* opts[:color]: string, hex value ('#00FF00')
* opts[:name]: string
* opts[:italic]: bool, default: false
* opts[:size]: fixnum
* opts[:strike_through]: bool, default: false
* opts[:shadow]: bool, default: false
* opts[:underline]: enum: :single, :double, :single_accounting, :double_accounting
* opts[:alignment]: enum: :subscript, :superscript

interior(opts={}):
* opts[:color]: string, hex value ('#00FF00')
* opts[:pattern]: enum (see code for options), default: :default
* opts[:pattern_color]: string, hex value ('#00FF00')

number_format(value):
* value: there are MANY different options for this, I suggest saving a spreadsheet in the XML format and seeing what Excel uses

protection(value):
* value: bool, default: false

## Usage

To generate a spreadsheet, create an Xmlss::Workbook instance and build the workbook using the above DSL.  Workbook takes three parameters:
* Xmlss::Writer instance
* data hash: (optional) key value data to bind to the workbook scope
* build block: (optional) block containing DSL directives

### Writer (Undies)

The Xmlss::Writer uses Undies (https://github.com/kellyredding/undies) to write the XML output.  The writer takes Undies::IO options.  See the Undies README for usage details.

```ruby
Xmlss::Workbook.new(Xmlss::Writer.new(:pp => 2)) do
  worksheet('A cool sheet') {
    ...
  }
end
```

### Data hash

Xmlss evals the build proc in the scope of the workbook instance.  This means that the build has access to only the data it is given or the DSL itself.  Data is given in the form of a Hash.  The string form of the hash keys are exposed as local workbook methods that return their corresponding values.

```ruby
Xmlss::Workbook.new(Xmlss::Writer.new, :sheet_name => 'A cool sheet') do
  worksheet(sheet_name) {
    ...
  }
end
```

### Builder approach

The above examples all pass in a build proc that is eval'd in the scope of the workbook instance.  This works great when you know your build at the same time you create your Workbook object.  However, in some cases, the build may not be known upfront or you may want to use a more declarative style to specify your spreadsheet content.  Workbook builds can be specified programmatically using the "builder" approach.

To render using this approach, create a Workbook instance passing it data and output info as above.  However, don't pass any build proc and save off the created workbook:

```ruby
# choosing not to use any local data or output options
workbook = Xmlss::Workbook.new(Xmlss::Writer.new)
```

Now just interact with the Workbook API directly.

```ruby
# notice that it becomes less important to bind any local data to the Workbook using this approach
something = "Some Thing!"
workbook.worksheet(something) {
  workbook.column

  workbook.row {
    workbook.cell {
      workbook.data "hi hi something hi"
    }
  }
}
```

# Disclaimer

Be aware this library only provides the basic, raw API for constructing spreadsheets using this spec and utilities to convert those objects to string xml data representing them.  It does not provide any macro logic to aid in constructing the sheets.  If you want a more convenient API for your use case, I suggest extending the objects and tailoring them to your needs.

You may also be interested in osheet-xmlss (https://github.com/kellyredding/osheet-xmlss).  I wrote this to use the more convenient Osheet workbook syntax to generate Xmlss workbooks.

The XML Spreadsheet spec and format are legacy and may have limited support depending on your version of MS Excel.  For a more modern spreadsheet generation method, I suggest looking into Office Open XML Workbook format (http://en.wikipedia.org/wiki/Office_Open_XML).

* Full XML Spreadsheet spec: http://msdn.microsoft.com/en-us/library/aa140066(office.10).aspx

## Installation

Add this line to your application's Gemfile:

    gem 'xmlss'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xmlss

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
