// Global jQuery utilities

$(function () {
  // ── Live Clock ──────────────────────────────────────────────
  function tick() {
    var now = new Date();
    var opts = { weekday: "short", day: "2-digit", month: "short" };
    var date = now.toLocaleDateString("id-ID", opts);
    var time = now.toLocaleTimeString("id-ID", {
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit",
    });
    $("#topbarClock").text(date + "  " + time);
  }
  tick();
  setInterval(tick, 1000);

  // ── Sidebar Toggle ──────────────────────────────────────────
  window.toggleSidebar = function () {
    var $sb = $("#sidebar");
    var $ov = $("#sidebarOverlay");
    var isMobile = $(window).width() < 992;

    if (isMobile) {
      $sb.toggleClass("open");
      $ov.toggleClass("show");
    } else {
      if ($sb.hasClass("collapsed")) {
        $sb.removeClass("collapsed").css("transform", "");
        $("#mainWrapper").css("margin-left", "var(--sidebar-w)");
      } else {
        $sb
          .addClass("collapsed")
          .css("transform", "translateX(calc(-1 * var(--sidebar-w)))");
        $("#mainWrapper").css("margin-left", "0");
      }
    }
  };

  // ── Toast Notification ──────────────────────────────────────
  window.showToast = function (msg, type) {
    type = type || "success";
    var colors = {
      success: "bg-success text-white",
      danger: "bg-danger text-white",
      warning: "bg-warning text-dark",
      info: "bg-info text-dark",
    };
    var $t = $("#toastMsg");
    $t.attr(
      "class",
      "toast align-items-center border-0 " + (colors[type] || colors.success),
    );
    $("#toastBody").text(msg);
    new bootstrap.Toast($t[0], { delay: 3500 }).show();
  };

  // ── Fade in content on load ─────────────────────────────────
  $("main.content-main").css("opacity", 0).animate({ opacity: 1 }, 250);

  // ── Bootstrap Tooltips ─────────────────────────────────────
  $("[title]").each(function () {
    new bootstrap.Tooltip(this, { placement: "top", trigger: "hover" });
  });
});
