"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // Users: add superadmin enum value, profilePicture, restaurantId, isActive
    await queryInterface.sequelize.query(
      `ALTER TYPE "enum_Users_role" ADD VALUE IF NOT EXISTS 'superadmin';`,
    );
    await queryInterface.addColumn("Users", "profilePicture", {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn("Users", "restaurantId", {
      type: Sequelize.INTEGER,
      allowNull: true,
    });
    await queryInterface.addColumn("Users", "isActive", {
      type: Sequelize.BOOLEAN,
      defaultValue: true,
      allowNull: false,
    });

    // MenuItems: add category, isVeg
    await queryInterface.addColumn("MenuItems", "category", {
      type: Sequelize.STRING,
      defaultValue: "Main Course",
      allowNull: true,
    });
    await queryInterface.addColumn("MenuItems", "isVeg", {
      type: Sequelize.BOOLEAN,
      defaultValue: false,
      allowNull: false,
    });

    // Restaurants: add adminId, phone, cuisine
    await queryInterface.addColumn("Restaurants", "adminId", {
      type: Sequelize.INTEGER,
      allowNull: true,
    });
    await queryInterface.addColumn("Restaurants", "phone", {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn("Restaurants", "cuisine", {
      type: Sequelize.STRING,
      allowNull: true,
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("Users", "profilePicture");
    await queryInterface.removeColumn("Users", "restaurantId");
    await queryInterface.removeColumn("Users", "isActive");
    await queryInterface.removeColumn("MenuItems", "category");
    await queryInterface.removeColumn("MenuItems", "isVeg");
    await queryInterface.removeColumn("Restaurants", "adminId");
    await queryInterface.removeColumn("Restaurants", "phone");
    await queryInterface.removeColumn("Restaurants", "cuisine");
  },
};
