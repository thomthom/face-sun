#-------------------------------------------------------------------------------
#
# Thomas Thomassen
# thomas[at]thomthom[dot]net
#
#-------------------------------------------------------------------------------

require 'sketchup.rb'


#-------------------------------------------------------------------------------

module TT::Plugins::FaceSun

### MENU & TOOLBARS ### ------------------------------------------------------

  unless file_loaded?( __FILE__ )
    plugin_menu = UI.menu('Plugin')
    plugin_menu.add_item('Face Sun') { self.face_sun }
  end


  ### MAIN SCRIPT ### ------------------------------------------------------

  def self.face_sun
    model = Sketchup.active_model

    self.start_operation("Face Sun")

    sun_vector = model.shadow_info["SunDirection"]
    model.selection.each { |e|
      next unless e.is_a?(Sketchup::Face)
      all_connected = e.all_connected
      bb = Geom::BoundingBox.new
      all_connected.map { |v| bb.add(v.bounds) }

      t1 = Geom::Transformation.new(bb.center, e.normal).invert!
      t2 = Geom::Transformation.new(bb.center, sun_vector)

      model.active_entities.transform_entities(t1, all_connected)
      model.active_entities.transform_entities(t2, all_connected)
    }

    model.commit_operation
  end


  ### HELPER METHODS ### ---------------------------------------------------

  def self.start_operation(name)
    model = Sketchup.active_model
    if Sketchup.version.split('.')[0].to_i >= 7
      model.start_operation(name, true)
    else
      model.start_operation(name)
    end
  end

end # module

#-------------------------------------------------------------------------------

file_loaded( __FILE__ )

#-------------------------------------------------------------------------------
