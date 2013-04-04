#!/usr/bin/env ruby
###############################################################################
# * ========================== GPL License =====================================
# * This program is free software; you can redistribute it and/or modify
# * it under the terms of the GNU General Public License as published by
# * the Free Software Foundation; either version 2 of the License, or
# * (at your option) any later version.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# * GNU Library General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with this program; if not, write to the Free Software
# * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
# * ============================================================================
###############################################################################
#
# Author: Emiliano Castagnari (<ecastag@gmail.com>)
#
###############################################################################

require 'optparse'
require 'json'

###############################################################################

class GetOpts
	def self.parse(args, file)
		begin
			json_data = File.read(file)
			options   = JSON.parse(json_data, { :symbolize_names => true })
			params = OptionParser.new do |opt|
				options.each { |attr, props|
					opt.on(props[:short], props[:long], props[:desc]) { |v|
					props[:value] = v
					}
				}
			end
			
			params.parse!(args)
			r = {}
			options.each { |k,f| r[k] = f[:value] }
			return r

		rescue Errno::ENOENT => msg
			print " ! File Exception: ", msg, "\n"
		rescue JSON::ParserError => msg
			print " ! JSON Exception: ", msg, "\n"
		end
	end
end

if __FILE__ == $0
	args = GetOpts.parse(ARGV, '../check_dns.json')
	p args
end

