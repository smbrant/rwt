#
#  ExtLib - (c) accesstecnologia.com.br
#
#  Array, with render capabilities for JSON
#  Basic javascript generator for array lists
#  Generates:
#    prologue
#    item1value, item2value, ...
#    epilogue
# 
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored
#   03/06/08, smb, allways use the model class name as root to json
#
require 'rubygems'
require 'active_support'

class Array

  #
  #  Returns a string with the JSON equivalent javascript
  #
  def render  # returns the redered javascript
    if block_given?
      yield self
    end

    js= Ext::Debug.indent+prologue+Ext::Debug.lf

    js<< Ext::fillArray(self)

    js<< Ext::Debug.indent+epilogue
  end

  def prologue
    @prologue || '['
  end
  def epilogue
    @epilogue || ']'
  end

  #  to_ext_json copied from ext_scaffold:
  #
  #  Copyright (c) 2008 martin.rehfeld@glnetworks.de
  #
  #  Permission is hereby granted, free of charge, to any person obtaining
  #  a copy of this software and associated documentation files (the
  #  "Software"), to deal in the Software without restriction, including
  #  without limitation the rights to use, copy, modify, merge, publish,
  #  distribute, sublicense, and/or sell copies of the Software, and to
  #  permit persons to whom the Software is furnished to do so, subject to
  #  the following conditions:
  #
  #  The above copyright notice and this permission notice shall be
  #  included in all copies or substantial portions of the Software.
  #
  #  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  #  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  #  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  #  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  #  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  #  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  #  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  #  
  #  New parameter: fields - an array of field names defining the data fields 
  #                           to be sent. smb, 25/07/08
  #
  
  def to_ext_json(options = {})
    if given_class = options.delete(:class)
      element_class = (given_class.is_a?(Class) ? given_class : given_class.to_s.classify.constantize)
    else
      element_class = first.class
    end
    element_count = options.delete(:count) || self.length
    fields= options.delete(:fields) || nil

#    { :results => element_count, element_class.table_name.to_s => self }.to_json(options)
    
#    if element_class.pluralize_table_names
#      { :results => element_count, element_class.to_s.underscore.pluralize => self }.to_json(options)
#    else
#      { :results => element_count, element_class.to_s.underscore => self }.to_json(options)
#    end

    if !fields # send complete records
      { :results => element_count.to_s, element_class.to_s.underscore => self }.to_json(options)        
    else # send just the data that whas asked for
      if !fields.include?('id')
        fields << 'id'
      end
      data=[]
      self.each do |record|
        clean_record={}
        fields.each do |f|
          clean_record[f.to_sym]=record.send(f).to_s
        end
        data << clean_record
      end
      { :results => element_count.to_s, element_class.to_s.underscore => data }.to_json(options)
    end
    
  end

  
end
