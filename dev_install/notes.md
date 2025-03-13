import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-root',
  template: '<router-outlet></router-outlet>',
})
export class AppComponent implements OnInit {
  constructor(private route: ActivatedRoute, private router: Router) {}

  ngOnInit() {
    // Subscribe to query parameters on startup
    this.route.queryParams.subscribe(params => {
      const license = params['license'];
      if (license) {
        // Set the license value in localStorage
        localStorage.setItem('LICENSE', license);
        
        // Optionally, remove the license parameter from the URL 
        // if you don't want it to remain visible.
        this.router.navigate([], {
          queryParams: { license: null },
          queryParamsHandling: 'merge'
        });
      }
    });
  }
}
