--[[ LICENSE HEADER
  
  MIT Licensing (see LICENSE.txt)
  
  Copyright © 2017 Jordan Irwin (AntumDeluge)
  
]]

--- Unimobiles settings script.
--
-- @module umobs.settings


--- Enables/Disables blood.
--
-- @setting enable_blood
--
-- - Type: (***bool***)
-- - Default: (***true***)
umobs.enable_blood = core.settings:get_bool('enable_blood') ~= false
