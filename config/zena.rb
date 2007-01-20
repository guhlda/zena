require 'date'
AUTHENTICATED_PREFIX = "oo"
ZENA_ENV = {
  :default_lang => 'en',
  :languages => ['en', 'fr', 'es'],
 # :news_collector_id => 24,
 # :menu_tag_id => 23,
  :moderate_public_comments => false,
  :site_name => 'zena',
  :root_id => 1,
  :authorize => false,
  :translate_group => 2, # default = admin
  :monolingual => false,
  :calendar_langs => ["en", "fr"],
  :password_salt => "fish zen ho"
}
# additions to class String
class String
  def limit(num)
    if length > num && num > 10
      self[0..(num-4)] + "..."
    elsif length > num
      self[0..(num-1)]
    else
      self
    end
  end
end

# this list is taken from http://www.duke.edu/websrv/file-extensions.html
EXT_TYPE = [
  [ "ai"        , "application/postscript"         ],
  [ "aif"       , "audio/x-aiff"                   ],
  [ "aifc"      , "audio/x-aiff"                   ],
  [ "aiff"      , "audio/x-aiff"                   ],
  [ "au"        , "audio/basic"                    ],
  [ "avi"       , "video/x-msvideo"                ],
  [ "bcpio"     , "application/x-bcpio"            ],
  [ "bin"       , "application/octet-stream"       ],
  [ "ccad"      , "application/clariscad"          ],
  [ "cdf"       , "application/x-netcdf"           ],
  [ "class"     , "application/octet-stream"       ],
  [ "cpio"      , "application/x-cpio"             ],
  [ "cpt"       , "application/mac-compactpro"     ],
  [ "csh"       , "application/x-csh"              ],
  [ "css"       , "text/css"                       ],
  [ "dcr"       , "application/x-director"         ],
  [ "dir"       , "application/x-director"         ],
  [ "dms"       , "application/octet-stream"       ],
  [ "doc"       , "application/msword"             ],
  [ "drw"       , "application/drafting"           ],
  [ "dvi"       , "application/x-dvi"              ],
  [ "dwg"       , "application/acad"               ],
  [ "dxf"       , "application/dxf"                ],
  [ "dxr"       , "application/x-director"         ],
  [ "eps"       , "application/postscript"         ],
  [ "etx"       , "text/x-setext"                  ],
  [ "exe"       , "application/octet-stream"       ],
  [ "ez"        , "application/andrew-inset"       ],
  [ "fli"       , "video/x-fli"                    ],
  [ "gif"       , "image/gif"                      ],
  [ "gtar"      , "application/x-gtar"             ],
  [ "gz"        , "application/x-gzip"             ],
  [ "hdf"       , "application/x-hdf"              ],
  [ "hqx"       , "application/mac-binhex40"       ],
  [ "htm"       , "text/html"                      ],
  [ "html"      , "text/html"                      ],
  [ "ice"       , "x-conference/x-cooltalk"        ],
  [ "ief"       , "image/ief"                      ],
  [ "iges"      , "model/iges"                     ],
  [ "igs"       , "model/iges"                     ],
  [ "ips"       , "application/x-ipscript"         ],
  [ "ipx"       , "application/x-ipix"             ],
  [ "jpg"       , "image/jpeg"                     ],
  [ "jpe"       , "image/jpeg"                     ],
  [ "jpeg"      , "image/jpeg"                     ],
  [ "js"        , "application/x-javascript"       ],
  [ "kar"       , "audio/midi"                     ],
  [ "latex"     , "application/x-latex"            ],
  [ "lha"       , "application/octet-stream"       ],
  [ "lsp"       , "application/x-lisp"             ],
  [ "lzh"       , "application/octet-stream"       ],
  [ "man"       , "application/x-troff-man"        ],
  [ "me"        , "application/x-troff-me"         ],
  [ "mesh"      , "model/mesh"                     ],
  [ "mid"       , "audio/midi"                     ],
  [ "midi"      , "audio/midi"                     ],
  [ "mif"       , "application/vnd.mif"            ],
  [ "mime"      , "www/mime"                       ],
  [ "mov"       , "video/quicktime"                ],
  [ "movie"     , "video/x-sgi-movie"              ],
  [ "mp2"       , "audio/mpeg"                     ],
  [ "mp3"       , "audio/mpeg"                     ],
  [ "mpe"       , "video/mpeg"                     ],
  [ "mpeg"      , "video/mpeg"                     ],
  [ "mpg"       , "video/mpeg"                     ],
  [ "mpga"      , "audio/mpeg"                     ],
  [ "ms"        , "application/x-troff-ms"         ],
  [ "msh"       , "model/mesh"                     ],
  [ "nc"        , "application/x-netcdf"           ],
  [ "oda"       , "application/oda"                ],
  [ "pbm"       , "image/x-portable-bitmap"        ],
  [ "pdb"       , "chemical/x-pdb"                 ],
  [ "pdf"       , "application/pdf"                ],
  [ "pgm"       , "image/x-portable-graymap"       ],
  [ "pgn"       , "application/x-chess-pgn"        ],
  [ "png"       , "image/png"                      ],
  [ "pnm"       , "image/x-portable-anymap"        ],
  [ "pot"       , "application/mspowerpoint"       ],
  [ "ppm"       , "image/x-portable-pixmap"        ],
  [ "pps"       , "application/mspowerpoint"       ],
  [ "ppt"       , "application/mspowerpoint"       ],
  [ "ppz"       , "application/mspowerpoint"       ],
  [ "pre"       , "application/x-freelance"        ],
  [ "prt"       , "application/pro_eng"            ],
  [ "ps"        , "application/postscript"         ],
  [ "qt"        , "video/quicktime"                ],
  [ "ra"        , "audio/x-realaudio"              ],
  [ "ram"       , "audio/x-pn-realaudio"           ],
  [ "ras"       , "image/cmu-raster"               ],
  [ "rb"        , "text/x-ruby-script"             ],
  [ "rgb"       , "image/x-rgb"                    ],
  [ "rm"        , "audio/x-pn-realaudio"           ],
  [ "roff"      , "application/x-troff"            ],
  [ "rpm"       , "audio/x-pn-realaudio-plugin"    ],
  [ "rtf"       , "text/rtf"                       ],
  [ "rtx"       , "text/richtext"                  ],
  [ "scm"       , "application/x-lotusscreencam"   ],
  [ "set"       , "application/set"                ],
  [ "sgm"       , "text/sgml"                      ],
  [ "sgml"      , "text/sgml"                      ],
  [ "sh"        , "application/x-sh"               ],
  [ "shar"      , "application/x-shar"             ],
  [ "silo"      , "model/mesh"                     ],
  [ "sit"       , "application/x-stuffit"          ],
  [ "skd"       , "application/x-koan"             ],
  [ "skm"       , "application/x-koan"             ],
  [ "skp"       , "application/x-koan"             ],
  [ "skt"       , "application/x-koan"             ],
  [ "smi"       , "application/smil"               ],
  [ "smil"      , "application/smil"               ],
  [ "snd"       , "audio/basic"                    ],
  [ "sol"       , "application/solids"             ],
  [ "spl"       , "application/x-futuresplash"     ],
  [ "src"       , "application/x-wais-source"      ],
  [ "step"      , "application/STEP"               ],
  [ "stl"       , "application/SLA"                ],
  [ "stp"       , "application/STEP"               ],
  [ "sv4cpio"   , "application/x-sv4cpio"          ],
  [ "sv4crc"    , "application/x-sv4crc"           ],
  [ "swf"       , "application/x-shockwave-flash"  ],
  [ "t"         , "application/x-troff"            ],
  [ "tar"       , "application/x-tar"              ],
  [ "tcl"       , "application/x-tcl"              ],
  [ "tex"       , "application/x-tex"              ],
  [ "texi"      , "application/x-texinfo"          ],
  [ "texinf"    , "application/x-texinfo"          ],
  [ "txt"       , "text/plain"                     ],
  [ "hh"        , "text/plain"                     ],
  [ "h"         , "text/plain"                     ],
  [ "asc"       , "text/plain"                     ],
  [ "c"         , "text/plain"                     ],
  [ "m"         , "text/plain"                     ],
  [ "cc"        , "text/plain"                     ],
  [ "f"         , "text/plain"                     ],
  [ "f90"       , "text/plain"                     ],
  [ "tiff"      , "image/tiff"                     ],
  [ "tr"        , "application/x-troff"            ],
  [ "tsi"       , "audio/TSP-audio"                ],
  [ "tsp"       , "application/dsptype"            ],
  [ "tsv"       , "text/tab-separated-values"      ],
  [ "unv"       , "application/i-deas"             ],
  [ "ustar"     , "application/x-ustar"            ],
  [ "vcd"       , "application/x-cdlink"           ],
  [ "vda"       , "application/vda"                ],
  [ "viv"       , "video/vnd.vivo"                 ],
  [ "vivo"      , "video/vnd.vivo"                 ],
  [ "vrml"      , "model/vrml"                     ],
  [ "wav"       , "audio/x-wav"                    ],
  [ "wrl"       , "model/vrml"                     ],
  [ "xbm"       , "image/x-xbitmap"                ],
  [ "xlc"       , "application/vnd.ms-excel"       ],
  [ "xll"       , "application/vnd.ms-excel"       ],
  [ "xlm"       , "application/vnd.ms-excel"       ],
  [ "xls"       , "application/vnd.ms-excel"       ],
  [ "xlw"       , "application/vnd.ms-excel"       ],
  [ "xml"       , "text/xml"                       ],
  [ "xpm"       , "image/x-xpixmap"                ],
  [ "xwd"       , "image/x-xwindowdump"            ],
  [ "xyz"       , "chemical/x-pdb"                 ],
  [ "zip"       , "application/zip"                ],
]

def make_hashes(h)
  val_to_keys = {}
  keys_to_val = {}
  h.each do |e|
    k,v = e
    if keys_to_val[k]
      keys_to_val[k] << v
    else
      keys_to_val[k] = [v]
    end
  
    if val_to_keys[v]
      val_to_keys[v] << k
    else
      val_to_keys[v] = [k]
    end
  end
  [keys_to_val, val_to_keys]
end

EXT_TO_TYPE, TYPE_TO_EXT = make_hashes(EXT_TYPE)