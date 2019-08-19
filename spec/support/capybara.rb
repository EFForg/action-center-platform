module CapybaraHelpers
  def select2(label, value, options={})
    label = find(:label, label)
    select2 = find("##{label['for']} + .select2")
    select2.click

    find(:xpath, "//body").find(".select2-results li", text: value).click
  end

  def fill_in_editor(label, with:)
    tag = find("label", text: label)
    parent = tag.first(:xpath, ".//..")

    iframe = parent.find("iframe")

    within_frame(iframe) do
      within_frame("epiceditor-editor-frame") do
        find("body[contenteditable]").set(with)
      end
    end
  end
end
