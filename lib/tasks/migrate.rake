namespace :migrate do
  desc "TODO"
  task permissions: :environment do
    User.update_user_permissions
  end

  desc "perform entire data migration"
  task setup: :environment do
    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    Rake::Task['db:schema:load'].execute
    Rake::Task['db:data:load'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['migrate:seed'].execute
    Rake::Task['migrate:permissions'].execute
  end

  desc "seed database with default values for new data structures"
  task seed: :environment do
    # seed roles to database
    roles = {
      'add_organisations' => {
        name: 'add_organisations'
      },
      'change_org_affiliation' => {
        name: 'change_org_affiliation'
      },
      'grant_permissions' => {
        name: 'grant_permissions'
      },
      'modify_templates' => {
        name: 'modify_templates'
      },
      'modify_guidance' => {
        name: 'modify_guidance'
      },
      'use_api' => {
        name: 'use_api'
      },
      'change_org_details' => {
        name: 'change_org_details'
      },
      'grant_api_to_orgs' => {
        name: 'grant_api_to_orgs'
      }
    }
    roles.each do |role, details|
      if Role.where(name: details[:name]).empty?
        role = Role.new
        role.name = details[:name]
        role.save!
      end
    end

    # seed token permission types to database
    token_permission_types = {
        'guidances' => {
            description: "allows a user access to the guidances api endpoint"
        },
        'plans' => {
            description: "allows a user access to the plans api endpoint"
        },
        'templates' => {
            description: "allows a user access to the templates api endpoint"
        },
        'statistics' => {
            description: "allows a user access to the statistics api endpoint"
        }
    }
    token_permission_types.each do |title,settings|
      if TokenPermissionType.where(token_type: title).empty?
        token_permission_type = TokenPermissionType.new
        token_permission_type.token_type = title
        token_permission_type.text_description = settings[:description]
        token_permission_type.save!
      end
    end

    # seed languages to database
    languages = {
        'English(UK)' => {
            abbreviation: 'en-UK',
            description: 'UK English language used as default',
            name: 'English(UK)',
            default_language: true
        },
        'FR' => {
            abbreviation: 'fr',
            description: '',
            name: 'fr',
            default_language: false
        },
        'DE' => {
            abbreviation: 'de',
            description: '',
            name: 'de',
            default_language: false
        }
    }

    languages.each do |l, details|
      if Language.where(name: details[:name]).empty?
        language = Language.new
        language.abbreviation = details[:abbreviation]
        language.description = details[:description]
        language.name = details[:name]
        language.default_language = details[:default_language]
        language.save!
      end
    end

    # seed regions to database
    regions = {
        'UK' => {
            abbreviation: 'uk',
            description: 'default region',
            name: 'UK',
        },
        'DE' => {
            abbreviation: 'de',
            description: '',
            name: 'DE',
        },
        'Horizon2020' => {
            abbreviation: 'horizon',
            description: 'European super region',
            name: 'Horizon2020',
        }
    }

    regions.each do |l, details|
      if Region.where(name: details[:name]).empty?
        region = Region.new
        region.abbreviation = details[:abbreviation]
        region.description = details[:description]
        region.name = details[:name]
        region.save!
      end
    end

  end
end
