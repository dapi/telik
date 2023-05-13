import consumer from "./consumer"

consumer.subscriptions.create("ProjectsChannel", {
  connected() {
    console.log('Connected');
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log('Received', data);
    var tbody = document.querySelector("table[data-projects-table] tbody");
    var projectRow = document.getElementById(`row_project_${data.project.id}`) || tbody.insertRow();
    projectRow.outerHTML=data.row;
  }
});
