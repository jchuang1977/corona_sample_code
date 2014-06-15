module( ..., package.seeall )

-- AngelCode bitmap font support

require( 'sprite' )

-- Specify an Angelcode format bitmap font definition file (".FNT")
-- The spritesheet(s) that this file references need to be located in the resource directory.
-- Return value is a font object that can be used when calling newString
function loadFont( fntFile )
  local function extract( s, p )
    return string.match( s, p ), string.gsub( s, p, '', 1 )
  end
  local font = { info = {}, spritesheets = {}, sprites = {}, chars = {}, kernings = {} }
  local readline = io.lines( system.pathForFile( fntFile, system.ResourceDirectory ) )
  for line in readline do
    local t = {}; local tag;
    tag, line = extract( line, '^%s*([%a_]+)%s*' )
    while string.len( line ) > 0 do
      local k, v
      k, line = extract( line, '^([%a_]+)=' )
      if not k then break end
      v, line = extract( line, '^"([^"]*)"%s*' )
      if not v then
        v, line = extract( line, '^([^%s]*)%s*' )
      end
      if not v then break end
      t[ k ] = v
    end
    if tag == 'info' or tag == 'common' then
      for k, v in pairs( t ) do font.info[ k ] = v end
    elseif tag == 'page' then
      font.spritesheets[ 1 + t.id ] = { file = t.file, frames = {} }
    elseif tag == 'char' then
      t.letter = string.char( t.id )
      font.chars[ t.letter ] = {}
      for k, v in pairs( t ) do font.chars[ t.letter ][ k ] = v end
      if 0 + font.chars[ t.letter ].width > 0 and 0 + font.chars[ t.letter ].height > 0 then
        font.spritesheets[ 1 + t.page ].frames[ #font.spritesheets[ 1 + t.page ].frames + 1 ] = {
          textureRect = { x = 0 + t.x, y = 0 + t.y, width = -1 + t.width, height = -1 + t.height },
          spriteSourceSize = { width = 0 + t.width, height = 0 + t.height },
          spriteColorRect = { x = 0, y = 0, width = -1 + t.width, height = -1 + t.height },
          spriteTrimmed = true
        }
        font.sprites[ t.letter ] = {
          spritesheet = 1 + t.page,
          frame = #font.spritesheets[ 1 + t.page ].frames
        }
      end
    elseif( tag == 'kerning' ) then
      font.kernings[ string.char( t.first ) .. string.char( t.second ) ] = 0 + t.amount
    end
  end
  for k, v in pairs( font.spritesheets ) do
    font.spritesheets[ k ].sheet = sprite.newSpriteSheetFromData( v.file, v )
  end
  for k, v in pairs( font.sprites ) do
    font.sprites[ k ] = sprite.newSpriteSet( font.spritesheets[ v.spritesheet ].sheet, v.frame, 1 )
  end
  return font
end

-- extend an object with accessor behaviors
local function accessorize( t )
  local mt = getmetatable( t )
  setmetatable( t, {
    __index = function( t, k )
      if rawget( t, 'get_'..k ) then
        return rawget(t, 'get_'..k )( t, k )
      elseif rawget( t, 'raw_'..k ) then
	      return rawget( t, 'raw_'..k )
      elseif mt.__index then
        return mt.__index( t, k )
      else
        return nil
	    end
    end,
    __newindex = function( t, k, v )
		  if rawget( t, 'set_'..k ) then
		    rawget( t, 'set_'..k )( t, k, v )
	    elseif rawget( t, 'raw_'..k ) then
	      rawset( t, 'raw_'..k, v )
	    elseif mt.__newindex then
	      mt.__newindex( t, k, v )
	    else
	      rawset( t, 'raw_'..k, v )
	    end
    end,
  } )
end

-- extend an object with cascading removeSelf
local function removerize( t )
  local old = t.removeSelf
  t.removeSelf = function( o )
    for i = o.numChildren, 1, -1 do o[ i ]:removeSelf() end
    old( o )
  end
end

-- Pass a font object (obtained from loadFont) and a string to render
-- Return value is a DisplayObject of the rendered string
-- object.font can be read/modifed
-- object.text can be read/modified
-- object.align can be read/modified - left/right/center (multiline not yet fully supported for non-left)
-- object.input( function(text), { filter = function(), max = 32 } )
--   turns the object into a text input.
--   the callback is hit when the user presses "return" or the field losed focus.
--   this code is under development - more documentation will be added soon...
function newString( font, text )
  local obj = display.newGroup()
  accessorize( obj )
  removerize( obj )
  obj.set_font = function( t, k, v )
    obj.raw_font = v
    if t.text then t.text = t.text end
  end
  obj.set_align = function( t, k, v )
		local w = t.contentWidth
		if t.raw_align == 'right' then
			for i = 1, t.numChildren do
				t[ i ].x = t[ i ].x - w
			end
		elseif t.raw_align == 'center' then
			for i = 1, t.numChildren do
				t[ i ].x = t[ i ].x + math.floor( w * 0.5 )
			end
		end
		t.raw_align = v
		if t.raw_align == 'right' then
			for i = 1, t.numChildren do
				t[ i ].x = t[ i ].x + w
			end
		elseif t.raw_align == 'center' then
			for i = 1, t.numChildren do
			  t[ i ].x = t[ i ].x - math.floor( w * 0.5 )
			end
		elseif t.raw_align ~= 'left' then
			t.raw_align = 'left'
		end
  end
  obj.set_text = function( t, k, v )
		t.raw_text = v
		for i = t.numChildren, 1, -1 do t[i]:removeSelf() end
		local oldAlign = ( t.align or 'left' )
		t.align = 'left'
		local x = 0; local y = 0
		local last = ''; local xMax = 0; local yMax = 0
		if t.raw_font then
			for c in string.gmatch( t.raw_text..'\n', '(.)' ) do
				if c == '\n' then
					x = 0; y = y + t.raw_font.info.lineHeight
					if y >= yMax then
						yMax = y
					end
				elseif t.raw_font.chars[ c ] then
					if 0 + t.raw_font.chars[ c ].width > 0 and 0 + t.raw_font.chars[ c ].height > 0 then
						local letter = sprite.newSprite( t.raw_font.sprites[ c ] )
						letter:setReferencePoint( display.TopLeftReferencePoint )
						if t.raw_font.kernings[ last .. c ] then
							x = x + font.kernings[ last .. c ]
						end
						letter.x = t.raw_font.chars[ c ].xoffset + x
						letter.y = t.raw_font.chars[ c ].yoffset - t.raw_font.info.base + y
						t:insert( letter )
						last = c
					end
					x = x + t.raw_font.chars[ c ].xadvance
					if x >= xMax then
						xMax = x
					end
				end
			end
		  local background = display.newRect( 0, -t.raw_font.info.base, xMax, yMax )
		  obj:insert( background )
		  background:setFillColor( 0, 0, 0, 0 )
		end
		t.align = oldAlign
	end
	obj.input = function( f, args )
		-- spawn the text field invisibly
		local field
		local function char()
			-- check if any character has been added or deleted
			if field.text ~= '--' then
				if string.len( field.text ) < 2 then
					-- backspace was pressed
					if string.len( obj.text ) > 0 then
						obj.text = string.sub( obj.text, 1, -2 )
					end
				else
					-- some other key was pressed
					obj.text = obj.text..string.sub( field.text, 3 )
				end
				field.text = '--'
				if args.filter then
					obj.text = string.sub( args.filter( obj.text ), 1, (args.max or 32) )
				else
					obj.text = string.sub( obj.text, 1, (args.max or 32) )
				end
			end
		end
		Runtime:addEventListener( 'enterFrame', char )
		local function done( e )
			if e.phase == 'submitted' or e.phase == 'ended' then
				native.setKeyboardFocus( nil )
				field:removeSelf()
				Runtime:removeEventListener( 'enterFrame', char )
				f( text )
			end
		end
		field = native.newTextField( 0, 0, 240, 24, done )
		field.text = '--'
		field.isVisible = false
		native.setKeyboardFocus( field )
	end
	obj.font = font
	obj.align = 'center'
  obj.text = (text or '')
  return obj
end
