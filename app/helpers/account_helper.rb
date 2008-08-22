# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

module AccountHelper
  def states_and_provinces
    c = Struct.new(:name, :states)
    s = Struct.new(:name, :abbreviation)
    canada = c.new('Canada', canada_provinces.collect { |province| s.new(province[0], province[1]) })
    us = c.new('United States', us_states.collect { |state| s.new(state[0], state[1]) })
    [us, canada]
  end
  
  def canada_provinces
    [
      %w{Alberta AB},
      ['British Columbia', 'BC'],
      %w{Manitoba MB},
      ['New Brunswick', 'NB'],
      ['Newfoundland and Labrador', 'NL'],
      ['Nova Scotia', 'NS'],
      %w{Ontario ON},
      ['Prince Edward Island', 'PE'],
      %w{Quebec QC},
      %w{Saskatchewan SK}
    ]
  end
  
  def us_states
    [
      %w{Alabama AL },
      %w{Alabama	AL },
      %w{Alaska AK },
      %w{Arizona	AZ },
      %w{Arkansas AR },
      %w{California CA },
      %w{Colorado CO },
      %w{Connecticut	CT },
      %w{Delaware DE },
      %w{Florida	FL },
      %w{Georgia	GA },
      %w{Hawaii HI },
      %w{Idaho	ID },
      %w{Illinois IL },
      %w{Indiana	IN },
      %w{Iowa IA },
      %w{Kansas KS },
      %w{Kentucky KY },
      %w{Louisiana	LA },
      %w{Maine	ME },
      %w{Maryland MD },
      %w{Massachusetts MA },
      %w{Michigan MI },
      %w{Minnesota	MN },
      %w{Mississippi	MS },
      %w{Missouri MO },
      %w{Montana	MT },
      %w{Nebraska NE },
      %w{Nevada NV },
      ['New Hampshire',	"NH" ],
      ['New Jersey', "NJ" ],
      ['New Mexico', "NM" ],
      ['New York', "NY" ],
      ['North Carolina',	"NC" ],
      ['North Dakota', "ND" ],
      %w{Ohio OH },
      %w{Oklahoma OK },
      %w{Oregon OR },
      %w{Pennsylvania PA },
      ['Rhode Island', "RI" ],
      ['South Carolina', "SC" ],
      ['South Dakota', "SD" ],
      %w{Tennessee	TN },
      %w{Texas	TX },
      %w{Utah UT },
      %w{Vermont	VT },
      %w{Virginia VA },
      %w{Washington WA },
      ['West Virginia',	"WV" ],
      %w{Wisconsin	WI },
      %w{Wyoming	WY },
    ]
  end
end
