class AddStatusToActionPages < ActiveRecord::Migration[5.0]
  def change
    add_column :action_pages, :status, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        # ----------------------------------------------------------
        #      new values          |      existing values
        # -------------------------|--------------------------------
        # enum int | semantic name | published | victory | archived
        # ---------|---------------|-----------|---------|----------
        #     0    | draft         |     0     |    0    |    0
        #     1    | live          |     1     |    0    |    0
        #     2    | victory       |   0 or 1  |    1    |    0
        #     3    | archived      |   0 or 1  |  0 or 1 |    1
        # ----------------------------------------------------------
        
        # Drafts
        execute("UPDATE action_pages SET status = 0 "\
                "WHERE published = FALSE AND victory = FALSE AND "\
                "archived = FALSE")
        # Live
        execute("UPDATE action_pages SET status = 1 "\
                "WHERE published = TRUE AND victory = FALSE AND "\
                "archived = FALSE")
        # Victories
        execute("UPDATE action_pages SET status = 2 "\
                "WHERE victory = TRUE AND archived = FALSE")

        # Archived
        execute("UPDATE action_pages SET status = 3 WHERE archived = TRUE")
      end
    end

    rename_column :action_pages, :victory, :old_victory
    rename_column :action_pages, :archived, :old_archived
  end
end
