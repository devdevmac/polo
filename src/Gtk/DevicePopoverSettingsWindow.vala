/*
 * DevicePopoverSettingsWindow.vala
 *
 * Copyright 2012-18 Tony George <teejeetech@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 *
 */


using Gtk;
using Gee;

using TeeJee.Logging;
using TeeJee.FileSystem;
using TeeJee.JsonHelper;
using TeeJee.ProcessHelper;
using TeeJee.GtkHelper;
using TeeJee.System;
using TeeJee.Misc;

public class DevicePopoverSettingsWindow : Gtk.Window {
	
	private Gtk.Box vbox_main;
	private Gtk.SizeGroup size_label;
	private Gtk.SizeGroup size_combo;
	
	private Gtk.Window window;
	
	public signal void settings_changed();
	
	public DevicePopoverSettingsWindow(Gtk.Window _window) {

		log_debug("DevicePopoverSettingsWindow: DevicePopoverSettingsWindow()");
		
		set_transient_for(_window);
		window_position = WindowPosition.CENTER_ON_PARENT;

		window = _window;

		set_modal(true);
		set_skip_taskbar_hint(true);
		set_skip_pager_hint(true);
		icon = get_app_icon(16);
		deletable = true;
		resizable = false;

		set_title(_("Settings"));
		
		vbox_main = new Gtk.Box(Orientation.VERTICAL, 6);
		vbox_main.margin = 12;
		vbox_main.set_size_request(400,300);
		this.add(vbox_main);

		init_options();

		init_actions();

		//show_all();
	}

	private void init_options() {

		log_debug("DevicePopoverSettingsWindow: init_options()");
		
		size_label = new Gtk.SizeGroup(Gtk.SizeGroupMode.HORIZONTAL);
		size_combo = new Gtk.SizeGroup(Gtk.SizeGroupMode.HORIZONTAL);

		init_dm_hide_size(vbox_main);

		init_dm_hide_fs(vbox_main);

		init_dm_hide_mp(vbox_main);

		init_dm_hide_header(vbox_main);

		init_width(vbox_main);

		init_height(vbox_main);
	}

	private void init_dm_hide_size(Gtk.Container box){

		var chk = new Gtk.CheckButton.with_label(_("Hide column: Size"));
		box.add(chk);

		chk.active = App.dm_hide_size;

		chk.toggled.connect(()=>{

			App.dm_hide_size = chk.active;

			settings_changed();
		});
	}

	private void init_dm_hide_fs(Gtk.Container box){

		var chk = new Gtk.CheckButton.with_label(_("Hide column: File System"));
		box.add(chk);

		chk.active = App.dm_hide_fs;

		chk.toggled.connect(()=>{

			App.dm_hide_fs = chk.active;

			settings_changed();
		});
	}

	private void init_dm_hide_mp(Gtk.Container box){

		var chk = new Gtk.CheckButton.with_label(_("Hide column: Mount Path"));
		box.add(chk);

		chk.active = App.dm_hide_mp;

		chk.toggled.connect(()=>{

			App.dm_hide_mp = chk.active;

			settings_changed();
		});
	}

	private void init_dm_hide_header(Gtk.Container box){

		var chk = new Gtk.CheckButton.with_label(_("Hide column headers"));
		box.add(chk);

		chk.active = App.dm_hide_header;

		chk.toggled.connect(()=>{

			App.dm_hide_header = chk.active;

			settings_changed();
		});
	}

	private void init_width(Gtk.Container box) {

		var hbox = new Gtk.Box(Orientation.HORIZONTAL, 12);
		box.add(hbox);
		hbox.add(new Gtk.Label(""));
		
		hbox = new Gtk.Box(Orientation.HORIZONTAL, 12);
		box.add(hbox);

		hbox.margin_left = 6;

		var label = new Gtk.Label(_("Width"));
		label.xalign = 0.0f;
		hbox.add(label);

		var spin = new Gtk.SpinButton.with_range(100, 2000, 100);
		spin.value = App.dm_width;
		spin.digits = 0;
		spin.xalign = 0.5f;
		hbox.add(spin);

		spin.value_changed.connect(()=>{
			
			App.dm_width = (int) spin.get_value();

			settings_changed();
		});

		size_label.add_widget(label);
		size_combo.add_widget(spin);
	}

	private void init_height(Gtk.Container box) {

		var hbox = new Gtk.Box(Orientation.HORIZONTAL, 12);
		box.add(hbox);

		hbox.margin_left = 6;

		var label = new Gtk.Label(_("Height"));
		label.xalign = 0.0f;
		hbox.add(label);

		var spin = new Gtk.SpinButton.with_range(100, 2000, 100);
		spin.value = App.dm_height;
		spin.digits = 0;
		spin.xalign = 0.5f;
		hbox.add(spin);

		spin.value_changed.connect(()=>{
			
			App.dm_height = (int) spin.get_value();

			settings_changed();
		});

		size_label.add_widget(label);
		size_combo.add_widget(spin);
	}

	private void init_actions() {

		var label = new Gtk.Label("");
		label.vexpand = true;
		vbox_main.add(label);
		
		var box = new Gtk.ButtonBox(Orientation.HORIZONTAL);
		box.set_layout(Gtk.ButtonBoxStyle.CENTER);
		box.set_spacing(6);
		vbox_main.add(box);
		
		var button = new Gtk.Button.with_label(_("Close"));
		box.add(button);

		button.clicked.connect(()=>{
			App.save_app_config();
			this.destroy();
		});

	}
}

